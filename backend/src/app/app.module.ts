import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { LoggerModule } from 'nestjs-pino';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersModule } from './users/users.module';
import { AuthModule } from './auth/auth.module';
import { User } from './entities/user.entity';
import { TrainingDay } from './entities/training-day.entity';
import { TrainingDayModule } from './training-day/training-day.module';
import { AssignedPlan } from './entities/assigned-plan.entity';
import { AssignedPlanModule } from './assigned-plan/assigned-plan.module';
import { TrainingDayFeedback } from './entities/training-day-feedback.entity';
import { TrainingDayFeedbackModule } from './training-day-feedback/training-day-feedback.module';
import { AiPlanModule } from './training-plan-ai/training-plan-ai.module';
import { TrainingPlanAi } from './entities/training-plan-ai.entity';

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
        entities: [
          User,
          TrainingDay,
          AssignedPlan,
          TrainingDayFeedback,
          TrainingPlanAi,
        ],
        synchronize: true,
        logging: true,
      }),
    }),

    UsersModule,
    AuthModule,
    TrainingDayModule,
    AssignedPlanModule,
    TrainingDayFeedbackModule,
    AiPlanModule,
  ],
})
export class AppModule {}
