import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from '../users/users.module';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { JwtStrategy } from './strategies/jwt.strategy';
import { RefreshJwtStrategy } from './strategies/refresh.strategy';
import { PinoLogger } from 'nestjs-pino';

@Module({
  imports: [
    UsersModule,
    PassportModule,
    JwtModule.register({}), // ConfigService injectuje vrednosti iz .env
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy, RefreshJwtStrategy, PinoLogger],
})
export class AuthModule {}
