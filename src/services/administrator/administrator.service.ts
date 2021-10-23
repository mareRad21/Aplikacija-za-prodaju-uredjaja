import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Administrator } from 'src/entities/administrator.entity';
import { AddAdministratorDto } from 'src/dtos/administrator/add.administrator.dto';
import { Repository } from 'typeorm/repository/Repository';
import * as crypto from "crypto";
import { EditAdministratorDto } from 'src/dtos/administrator/edit.administrator.dto';
import { ApiResponse } from 'src/misc/api.response.class';

@Injectable()
export class AdministratorService {
    constructor(
        @InjectRepository(Administrator)
        private readonly administrator: Repository<Administrator>,
    ){ }

    getAll(): Promise<Administrator[]>{
        return this.administrator.find();
    }

    async getByUsername(usernameAdmin: string): Promise<Administrator | null> {
        const admin = await this.administrator.findOne({
            username: usernameAdmin
        });
        if(admin){
            return admin;
        }
        return null;
    }

    getById(id: number): Promise<Administrator | ApiResponse>{

        return new Promise(async (resolve)=>{
            let admin = await this.administrator.findOne(id);
            if(admin === undefined){
                resolve(new ApiResponse("error",-1002));
            }
            resolve(admin);
        });
    }

    add(data: AddAdministratorDto): Promise<Administrator | ApiResponse>{
        const passwordHash = crypto.createHash('sha512');
        passwordHash.update(data.password);

        const passwordHashString = passwordHash.digest('hex').toUpperCase();

        let newAdmin = new Administrator();
        newAdmin.username = data.username;
        newAdmin.passwordHash = passwordHashString;

        return new Promise((resolve) =>{
            this.administrator.save(newAdmin)
            .then(data => resolve(data))
            .catch(error =>{
                const response: ApiResponse = new ApiResponse("error", -1001);
                resolve(response);
            });
        }); 
    }
    async editById(id: number, data: EditAdministratorDto): Promise<Administrator | ApiResponse>{
        let admin: Administrator = await this.administrator.findOne(id);

        if (admin === undefined) {
            return new Promise((resolve) => {
                resolve(new ApiResponse("error", -1002));
            });
        }
        const passwordHash = crypto.createHash('sha512');
        passwordHash.update(data.password);

        const passwordHashString = passwordHash.digest('hex').toUpperCase();

        admin.passwordHash = passwordHashString;

        return this.administrator.save(admin);
    }
    //deleteById
}
