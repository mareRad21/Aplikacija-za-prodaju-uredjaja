import { Body, Controller, Delete, Param, Post, Req, UploadedFile, UseInterceptors } from "@nestjs/common";
import { FileInterceptor } from "@nestjs/platform-express";
import { Crud } from "@nestjsx/crud";
import { Article } from "src/entities/article.entity";
import { AddArticleDto } from "src/dtos/article/add.article.dto";
import { ApiResponse } from "src/misc/api.response.class";
import { ArticleService } from "src/services/article/article.service";
import {diskStorage} from "multer";
import { PhotoService } from "src/services/photo/photo.service";
import { Photo } from "src/entities/photo.entity";
import { StorageConfiguration } from "config/storage.configuration";
import * as fileType from "file-type";
import * as fs from "fs";
import * as sharp from "sharp";

@Controller('api/article')
@Crud({
    model:{
        type: Article
    },
    params:{
        id:{
            field: 'articleId',
            type:'number',
            primary:true
        }
    },
    query:{
        join:{
            category: {
                eager: true
            },
            photos: {
                eager: true
            },
            articlePrices:{
                eager:true
            },
            articleFeatures:{
                eager:true
            },
            features: {
                eager:true
            }
        }
    }
})
export class ArticleController {
    constructor(
        public service:ArticleService,
        public photoService: PhotoService){};
    
    @Post('createFull')
    createFullArticle(@Body() data:AddArticleDto): Promise<Article | ApiResponse>{
        return this.service.createFullArticle(data);
    }

    @Post(':id/uploadPhoto')
    @UseInterceptors(
        FileInterceptor('photo',{
            storage: diskStorage({
                destination: StorageConfiguration.photo.destination,
                filename: (req, file, callback)=>{
                    let original:string = file.originalname;
                    let normalized = original.replace(/\s+/g, '-');
                    normalized.replace(/^[A-z0-9\.\-]/g,'');
                    let currentTime = new Date();
                    let datePart = '';
                    datePart += currentTime.getFullYear().toString();
                    datePart += (currentTime.getMonth() + 1).toString();
                    datePart += currentTime.getDate().toString();

                    let randomPart: string = new Array(10).fill(0).map(e=> (Math.random() *10).toFixed(0).toString()).join('');

                    let fileName = datePart + '-'+randomPart+'-'+normalized;

                    fileName = fileName.toLowerCase();

                    callback(null, fileName);
                }
            }),
            fileFilter: (req, file, callback)=>{
                //Check extension
                if(!file.originalname.toLowerCase().match(/\.(jp|pn)g$/)){
                    req.fileFilterError = "Bad file extension!"
                    callback(null, false);
                    return;
                }
                //Check content type image/jpeg or image/png (mymetype)
                if(!(file.mimetype.includes('jpeg') || file.mimetype.includes('png'))){
                    req.fileFilterError = "Bad file content type!"
                    callback(null, false);
                    return;
                }

                callback(null, true);
            },
            limits:{
                files: 1,
                fileSize: StorageConfiguration.photo.maxSize
            }
        })
    )
    async uploadPhoto(
        @Param('id') articleId: number,
        @UploadedFile() photo,
        @Req() req
        ): Promise<ApiResponse|Photo>{
        if(req.fileFilterError){
            return new ApiResponse('error',-4002,req.fileFilterError);
        }
        if(!photo){
            return new ApiResponse('error',-4003, "File not uploaded!");
        }
        // Read the uploaded file
        const fileTypeResult = await fileType.fromFile(photo.path);
        if(!fileTypeResult){
            //TODO: Delete File
            fs.unlinkSync(photo.path);
            return new ApiResponse('error',-4002, "Cannot detect file type!" );
        }

         //TODO: Real Mime Type Check 

        const realMimeType = fileTypeResult.mime;

        if(!(realMimeType.includes('jpeg') || realMimeType.includes('png'))){
            //TODO: Delete File
            fs.unlinkSync(photo.path);
            return new ApiResponse('error',-4002,"Bad file content type!");
        }
        
        //TODO: Save Resized Photo
        await this.createResizedImage(photo, StorageConfiguration.photo.resize.thumb);
        await this.createResizedImage(photo, StorageConfiguration.photo.resize.small);

        const newPhoto:Photo = new Photo();
        newPhoto.articleId = articleId;
        newPhoto.imagePath = photo.filename;

        const savedPhoto = await this.photoService.add(newPhoto);

        if(!savedPhoto){
            return new ApiResponse('error',-4001);
        }
        return savedPhoto;
    }

    async createResizedImage(photo, resizeSettings){
        const orignialFilePath = photo.path;
        const fileName = photo.filename;

        const destinationFilePath = StorageConfiguration.photo.destination + resizeSettings.directory + fileName;
        await sharp(orignialFilePath)
            .resize({
            fit: 'contain',
            width: resizeSettings.width,
            height: resizeSettings.height,
            background: {
                r: 255, g: 255, b: 255, alpha: 0.0
            }
        })
        .toFile(destinationFilePath);

    }

    @Delete(':articleId/deletePhoto/:photoId/')
    public async deletephoto(@Param ('articleId') articleId: number, @Param('photoId') photoId: number){

        const photo = await this.photoService.findOne({
            articleId: articleId,
            photoId:photoId
        });

        if(!photo){
            return new ApiResponse('error',-4004, 'Photo not found');
        }
        try{
            fs.unlinkSync(StorageConfiguration.photo.destination + photo.imagePath);
            fs.unlinkSync(StorageConfiguration.photo.destination + StorageConfiguration.photo.resize.thumb.directory +photo.imagePath);
            fs.unlinkSync(StorageConfiguration.photo.destination + StorageConfiguration.photo.resize.small.directory + photo.imagePath);
        } catch(e){
            return new ApiResponse('error',-4004,'Delete option could not be possible on no existing file!');
        }
       

        const deleteResult = await this.photoService.deleteById(photo.photoId);

        if(deleteResult.affected === 0){
            return new ApiResponse('error',-4004,'Photo not found!');
        }

        return new ApiResponse('ok',0,'Photo is deleted')
    }
}