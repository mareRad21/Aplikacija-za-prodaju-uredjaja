import { Column, Entity, Index, PrimaryGeneratedColumn } from "typeorm";
import * as Validator from 'class-validator';

@Index("uq_administrator_user", ["username"], {unique:true})
@Entity("administrator")
export class Administrator{
    @PrimaryGeneratedColumn({
        type: 'int',
        name: 'administrator_id',
        unsigned: true 
    })
    administratorId: number;

    @Column({
        type:'varchar', 
        name: 'username',  
        length: 32, 
        unique: true})
    @Validator.IsNotEmpty()
    @Validator.IsString()
    @Validator.Matches(/^[a-z][a-z0-9\.]{3,30}[a-z0-9]$/)

    username: string;

    @Column({
        type:'varchar', 
        name: 'password_hash', 
        length: 128 
    })
    @Validator.IsNotEmpty()
    @Validator.IsHash('sha512')
    passwordHash: string;
}