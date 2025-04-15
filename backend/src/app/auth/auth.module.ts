import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from '../users/users.module';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { JwtStrategy } from './strategies/jwt.strategy';
import { RefreshJwtStrategy } from './strategies/refresh.strategy';
import { LocalStrategy } from './strategies/local.strategy';
import { RoleAuthGuard } from './guards/role-auth.guard';
import { PinoLogger } from 'nestjs-pino';

@Module({
  imports: [
    UsersModule,
    PassportModule,
    JwtModule.register({}), // konfiguracija ide iz .env i `JwtService`
  ],
  controllers: [AuthController],
  providers: [
    AuthService,
    JwtStrategy,
    RefreshJwtStrategy,
    LocalStrategy,
    RoleAuthGuard,
    PinoLogger,
  ],
})
export class AuthModule {}
