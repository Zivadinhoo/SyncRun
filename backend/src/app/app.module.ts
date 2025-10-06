import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { LoggerModule } from 'nestjs-pino';
import { TypeOrmModule } from '@nestjs/typeorm';

import { UsersModule } from './users/users.module';
import { AuthModule } from './auth/auth.module';
import { TrainingDayModule } from './training-day/training-day.module';
import { TrainingDayFeedbackModule } from './training-day-feedback/training-day-feedback.module';

@Module({
  imports: [
    // 🔹 Globalni Config za .env
    ConfigModule.forRoot({
      envFilePath: '.env',
      isGlobal: true,
    }),

    // 🔹 Lepši logovi (pino-pretty)
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

    // 🔹 TypeORM konekcija na Supabase (pooler)
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        type: 'postgres',
        url: config.get<string>('DATABASE_URL')!,
        ssl: { rejectUnauthorized: false },
        extra: { prepareThreshold: 0 }, // bitno za pooler
        autoLoadEntities: true, // automatski učitava sve entitete iz modula
        synchronize: true, // za razvoj; kasnije prebaci na false
        logging: true,
      }),
    }),

    UsersModule,
    AuthModule,
    TrainingDayModule,
    TrainingDayFeedbackModule,
  ],
})
export class AppModule {}
