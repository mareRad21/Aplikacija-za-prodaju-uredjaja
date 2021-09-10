import { Controller, Get } from '@nestjs/common';
import { Administrator } from 'entities/administrator.entity';
import { User } from 'entities/user.entity';
import { UserService } from 'src/services/user/user.service';
import { AdministratorService } from '../services/administrator/administrator.service';


@Controller()
export class AppController {

  constructor(
    private administratorService: AdministratorService,
    private userService: UserService
  ){}
 

  @Get()        // http://localhost:3000/
  getIndex(): string {
    return 'Home page!';
  }
 
  @Get('api/users')
  getAllUsers(): Promise<User[]>{
    return this.userService.getAll();
  }
}
