import { Body, Controller, Get, Param, Post, Put, UseGuards } from "@nestjs/common";
import { Administrator } from "src/entities/administrator.entity";
import { AddAdministratorDto } from "src/dtos/administrator/add.administrator.dto";
import { EditAdministratorDto } from "src/dtos/administrator/edit.administrator.dto";
import { ApiResponse } from "src/misc/api.response.class";
import { AdministratorService } from "src/services/administrator/administrator.service";
import { AllowToRoles } from "src/misc/allow.to.roles.descriptor";
import { RoleCheckerGuard } from "src/misc/role.checker.guard";

@Controller('api/administrator')
export class AdministratorController{
    constructor(
        private administratorService:AdministratorService
    ){}

    @Get()
    @AllowToRoles('administrator')
    @UseGuards(RoleCheckerGuard)
    getAll(): Promise<Administrator[]>{
      return this.administratorService.getAll();
    }

    @Get(':id')
    @AllowToRoles('administrator')
    @UseGuards(RoleCheckerGuard)
    getById( @Param('id') administratorId: number): Promise<Administrator | ApiResponse>{
      return this.administratorService.getById(administratorId);
    }

    @Post()
    @AllowToRoles('administrator')
    @UseGuards(RoleCheckerGuard)
    add(@Body() data: AddAdministratorDto): Promise<Administrator | ApiResponse>{
      return this.administratorService.add(data);
    }

    @Put(':id')
    @AllowToRoles('administrator')
    @UseGuards(RoleCheckerGuard)
    edit(@Param('id') id:number, @Body() data: EditAdministratorDto): Promise<Administrator | ApiResponse>{
      return this.administratorService.editById(id, data);
    }
    
}