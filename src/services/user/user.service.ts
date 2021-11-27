import { Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { TypeOrmCrudService } from "@nestjsx/crud-typeorm";
import { UserRegistrationDto } from "src/dtos/user/user.registration.dto";
import { User } from "src/entities/user.entity";
import { ApiResponse } from "src/misc/api.response.class";
import { Repository } from "typeorm";
import * as crypto from "crypto";

@Injectable()
export class UserService extends TypeOrmCrudService<User>{
    constructor(@InjectRepository(User) private readonly user: Repository<User>){
        super(user);
    }

    async getById(id: number){
        return await this.user.findOne(id);
    }

    async getByEmail(userEmail: string): Promise<User | null> {
        const user = await this.user.findOne({
            email: userEmail
        } 
        );
        if(user){
            return user;
        }
        return null;
    }

    async register(data: UserRegistrationDto): Promise<User|ApiResponse>{
        const passwordHash = crypto.createHash('sha512');
        passwordHash.update(data.password);
        const passwordHashSting = passwordHash.digest('hex').toUpperCase();

        const newUser: User   = new User();
        newUser.email         = data.email;
        newUser.passwordHash  = passwordHashSting;
        newUser.forename      = data.forename;
        newUser.surname       = data.surname;
        newUser.phoneNumber   = data.phoneNumber;
        newUser.postalAddress = data.postalAddress;
        
        try {
            const savedUser = await this.user.save(newUser);
            if(!savedUser){
                throw new Error("");
            }

            return savedUser;
        } catch (error) {
            return new ApiResponse('error', -6001, "This user account cannot be created!")
        }
    }
}