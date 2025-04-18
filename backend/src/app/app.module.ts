import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { LoggerModule } from 'nestjs-pino';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersModule } from './users/users.module';
import { AuthModule } from './auth/auth.module';
import { User } from './entities/user.entity';
import { TrainingPlan } from './entities/training-plan.entity';
import { TrainingPlanModule } from './training-plan/training-plan.module';
import { TrainingDay } from './entities/training-day.entity';
import { TrainingDayModule } from './training-day/training-day.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      envFilePath: '.env',
      isGlobal: true,
    }),

    LoggerModule.forRoot({
      pinoHttp: {
        transport: {
          target: 'pino-pretty',
          options: {
            colorize: true,
            translateTime: 'HH:MM:ss',
            ignore: 'pid,hostname',
          },
        },
      },
    }),

    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        type: 'postgres',
        host: config.get('DATABASE_HOST'),
        port: config.get<number>('DATABASE_PORT'),
        username: config.get('DATABASE_USER'),
        password: config.get('DATABASE_PASSWORD'),
        database: config.get('DATABASE_NAME'),
        entities: [User, TrainingPlan, TrainingDay],
        synchronize: true,
        logging: true,
      }),
    }),

    UsersModule,
    AuthModule,
    TrainingPlanModule,
    TrainingDayModule,
  ],
})
export class AppModule {}
