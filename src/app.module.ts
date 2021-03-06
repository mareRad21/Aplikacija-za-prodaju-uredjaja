import { MailerModule } from '@nestjs-modules/mailer';
import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { databaseConfiguration } from 'config/database.configuration';
import { MailConfig } from 'config/mail.config';
import { Administrator } from 'src/entities/administrator.entity';
import { ArticleFeature } from 'src/entities/article-feature.entity';
import { ArticlePrice } from 'src/entities/article-price.entity';
import { Article } from 'src/entities/article.entity';
import { CartArticle } from 'src/entities/cart-article.entity';
import { Cart } from 'src/entities/cart.entity';
import { Category } from 'src/entities/category.entity';
import { Feature } from 'src/entities/feature.entity';
import { Order } from 'src/entities/order.entity';
import { Photo } from 'src/entities/photo.entity';
import { User } from 'src/entities/user.entity';
import { AdministratorController } from './controllers/api/administrator.controller';
import { AdministratorOrderController } from './controllers/api/administrator.order.controller';
import { ArticleController } from './controllers/api/article.controller';
import { AuthController } from './controllers/api/auth.controller';
import { CategoryController } from './controllers/api/category.controller';
import { FeatureController } from './controllers/api/feature.controller';
import { UserCartController } from './controllers/api/user.cart.controller';
import { AppController } from './controllers/app.controller';
import { UserToken } from './entities/user-token.entity';
import { AuthMiddleware } from './middelwares/auth.middleware';
import { AdministratorService } from './services/administrator/administrator.service';
import { ArticleService } from './services/article/article.service';
import { CartService } from './services/cart/cart.service';
import { CategoryService } from './services/category/category.service';
import { FeatureService } from './services/feature/feature.service';
import { OrderMailer } from './services/order/order.mailer.service';
import { OrderService } from './services/order/order.service';
import { PhotoService } from './services/photo/photo.service';
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
        UserToken
        ]
    }),
    TypeOrmModule.forFeature([
      Administrator,
      Article, 
      ArticlePrice,
      ArticleFeature,
      CartArticle, 
      Cart, 
      Category, 
      Feature, 
      Order,
      Photo, 
      User,
      UserToken
    ]),
    MailerModule.forRoot({
      transport: {
        host: MailConfig.hostname,
        port: 587,
        secure: false,
        auth: {
          user: MailConfig.username,
          pass: MailConfig.password,
        },
        tls:{
          rejectUnauthorized:false
        }
      },
      defaults: {
        from: MailConfig.senderEmail,
      },
    }),
  ],
  controllers: [AppController, AdministratorController,AdministratorOrderController, ArticleController, CategoryController, FeatureController, AuthController,UserCartController],
  providers: [AdministratorService, ArticleService, CategoryService,CartService, FeatureService, OrderService, OrderMailer, PhotoService, UserService],
  exports: [AdministratorService, UserService]
})


export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer){
    consumer
    .apply(AuthMiddleware)
    .exclude('auth/*')
    .forRoutes('api/*')
  }
}
