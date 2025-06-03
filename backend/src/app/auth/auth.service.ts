import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PinoLogger } from 'nestjs-pino';
import * as bcrypt from 'bcrypt';
import { User } from '../entities/user.entity';
import { ConfigService } from '@nestjs/config';
import { AuthResponse } from './interfaces/auth-response.interface';

@Injectable()
export class AuthService {
  constructor(
    private readonly configService: ConfigService,
    private readonly jwtService: JwtService,
    private readonly logger: PinoLogger,
  ) {
    this.logger.setContext(AuthService.name);
  }

  async authorize(user: User): Promise<AuthResponse> {
    const accessToken = await this.generateAccessToken(user);
    const refreshToken = await this.generateRefreshToken(user);

    return {
      accessToken,
      refreshToken,
      userId: user.id,
      email: user.email,
      role: user.role,
      fullName: `${user.firstName} ${user.lastName}`,
    };
  }

  async generateHashedPassword(password: string): Promise<string> {
    return await bcrypt.hash(password, 10);
  }

  async isPasswordValid(
    password: string,
    hashedPassword: string,
  ): Promise<boolean> {
    return await bcrypt.compare(password, hashedPassword);
  }

  private async generateAccessToken(user: User): Promise<string> {
    const secret = this.configService.get<string>('JWT_SECRET') ?? '';
    return await this.jwtService.signAsync(
      {
        email: user.email,
        role: user.role,
        sub: user.id,
      },
      {
        secret,
        expiresIn: '1h',
      },
    );
  }

  private async generateRefreshToken(user: User): Promise<string> {
    const secret = this.configService.get<string>('JWT_REFRESH_SECRET') ?? '';
    return await this.jwtService.signAsync(
      {
        email: user.email,
        role: user.role,
        sub: user.id,
      },
      {
        secret,
        expiresIn: '7d',
      },
    );
  }
}
