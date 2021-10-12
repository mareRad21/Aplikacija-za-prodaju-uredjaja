import { Body, Controller, Param, Post, UploadedFile, UseInterceptors } from "@nestjs/common";
import { FileInterceptor } from "@nestjs/platform-express";
import { Crud } from "@nestjsx/crud";
import { Article } from "entities/article.entity";
import { AddArticleDto } from "src/dtos/article/add.article.dto";
import { ApiResponse } from "src/misc/api.response.class";
import { ArticleService } from "src/services/article/article.service";
import {diskStorage} from "multer";
import { PhotoService } from "src/services/photo/photo.service";
import { Photo } from "entities/photo.entity";
import { StorageConfiguration } from "config/storage.configuration";

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
                destination: StorageConfiguration.photoDestination,
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
                    callback(new Error("Bad file extentions!"), false);
                    return;
                }
                //Check content type image/jpeg or image/png (mymetype)
                if(!(file.mimetype.includes('jpeg') || file.mimetype.includes('png'))){
                    callback(new Error("Bad type content!"), false);
                    return;
                }

                callback(null, true);
            },
            limits:{
                files: 1,
                fieldSize: StorageConfiguration.photoMaxFileSize
            }
        })
    )
    async uploadPhoto(@Param('id') articleId: number, @UploadedFile() photo): Promise<ApiResponse|Photo>{
        const newPhoto:Photo = new Photo();
        newPhoto.articleId = articleId;
        newPhoto.imagePath = photo.filename;

        const savedPhoto = await this.photoService.add(newPhoto);

        if(!savedPhoto){
            return new ApiResponse('error',-4001);
        }
        return savedPhoto;
    }
}