import { HttpException, HttpStatus, Injectable, NestMiddleware } from "@nestjs/common";
import { NextFunction, Request, Response } from "express";
import { AdministratorService } from "src/services/administrator/administrator.service";
import * as jwt from "jsonwebtoken";
import { JwtDataAdministratorDto } from "src/dtos/administrator/jwt.data.adminsitrator.dto";
import { jwtSecret } from "config/jwt.secret";

@Injectable()
export class AuthMiddleware implements NestMiddleware {

    constructor(private readonly admnistratorService: AdministratorService){}

    async use(req: Request, res: Response, next: NextFunction) {
        if(!req.headers.authorization){
            throw new HttpException('Token not found',HttpStatus.UNAUTHORIZED);
        }

        const token = req.headers.authorization.toString();

        const tokenParts = token.split(' ');

        if(tokenParts.length !==2){
            throw new HttpException('Bad token found',HttpStatus.UNAUTHORIZED);
        }

        const tokenString = tokenParts[1];

       let jwtData: JwtDataAdministratorDto;
        try {
            jwtData = jwt.verify(tokenString, jwtSecret);
        } catch(e){
            throw new HttpException('Bad token found-kita',HttpStatus.UNAUTHORIZED);
        }

        if(!jwtData){
            throw new HttpException('Bad token found',HttpStatus.UNAUTHORIZED);
        }
        
        if(jwtData.ip !== req.ip.toString()){
            throw new HttpException('Bad token found',HttpStatus.UNAUTHORIZED);
        }
        
        if(jwtData.ua !== req.headers["user-agent"]){
            throw new HttpException('Bad token found',HttpStatus.UNAUTHORIZED);
        }

        const administrator = await this.admnistratorService.getById(jwtData.adminstratorId);

        if(!administrator){
            throw new HttpException('Account not found',HttpStatus.UNAUTHORIZED);
        }

        const currentTimeStamp = new Date().getTime() / 1000;

        if(currentTimeStamp >= jwtData.exp){
            throw new HttpException('The token has expired',HttpStatus.UNAUTHORIZED);
        }
        

        next();
    }

}