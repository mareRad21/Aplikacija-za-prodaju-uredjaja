import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { databaseConfiguration } from 'config/database.configuration';
import { Administrator } from 'entities/administrator.entity';
import { ArticleFeature } from 'entities/article-feature.entity';
import { ArticlePrice } from 'entities/article-price.entity';
import { Article } from 'entities/article.entity';
import { CartArticle } from 'entities/cart-article.entity';
import { Cart } from 'entities/cart.entity';
import { Category } from 'entities/category.entity';
import { Feature } from 'entities/feature.entity';
import { Order } from 'entities/order.entity';
import { Photo } from 'entities/photo.entity';
import { User } from 'entities/user.entity';
import { AdministratorController } from './controllers/api/administrator.controller';
import { AppController } from './controllers/app.controller';
import { AdministratorService } from './services/administrator/administrator.service';
import { UserService } from './services/user/user.service';


@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: databaseConfiguration.hostname,
      username: databaseConfiguration.username,
      password: databaseConfiguration.password,
      database: databaseConfiguration.database,
      port: 3306,
      entities: [
        Administrator,
        ArticleFeature,
        ArticlePrice,
        Article,
        CartArticle,
        Cart,
        Category,
        Feature,
        Order,
        Photo,
        User,
        ]
    }),
    TypeOrmModule.forFeature([Administrator, User])
  ],
  controllers: [AppController, AdministratorController],
  providers: [AdministratorService, UserService]
})
export class AppModule {}
