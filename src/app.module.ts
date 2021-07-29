import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { databaseConfiguration } from 'config/database.configuration';
import { Administrator } from 'entities/administrator.entity';
import { AppController } from './app.controller';
import { AdministratorService } from './services/administrator/administrator.service';


@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: databaseConfiguration.hostname,
      username: databaseConfiguration.username,
      password: databaseConfiguration.password,
      database: databaseConfiguration.database,
      port: 3306,
      entities: [Administrator]
    }),
    TypeOrmModule.forFeature([Administrator])
  ],
  controllers: [AppController],
  providers: [AdministratorService]
})
export class AppModule {}
