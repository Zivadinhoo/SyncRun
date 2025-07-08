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

  /**
   * Return full authentication response with tokens and user info.
   */
  async authorize(user: User): Promise<AuthResponse> {
    const accessToken = await this.generateAccessToken(user);
    const refreshToken = await this.generateRefreshToken(user);

    return {
      accessToken,
      refreshToken,
      userId: user.id,
      email: user.email,
      fullName: `${user.firstName} ${user.lastName}`,
    };
  }

  /**
   * Hash plain password using bcrypt.
   */
  async generateHashedPassword(password: string): Promise<string> {
    return bcrypt.hash(password, 10);
  }

  /**
   * Check password validity using bcrypt.
   */
  async isPasswordValid(
    password: string,
    hashedPassword: string,
  ): Promise<boolean> {
    return bcrypt.compare(password, hashedPassword);
  }

  /**
   * Generate access token with 1h expiration.
   */
  private async generateAccessToken(user: User): Promise<string> {
    const secret = this.configService.get<string>('JWT_SECRET');
    if (!secret) {
      this.logger.error('❌ JWT_SECRET not set in config');
      throw new Error('JWT_SECRET not configured');
    }

    return this.jwtService.signAsync(
      {
        sub: user.id,
        email: user.email,
      },
      {
        secret,
        expiresIn: '1h',
      },
    );
  }

  /**
   * Generate refresh token with 7d expiration.
   */
  private async generateRefreshToken(user: User): Promise<string> {
    const secret = this.configService.get<string>('JWT_REFRESH_SECRET');
    if (!secret) {
      this.logger.error('❌ JWT_REFRESH_SECRET not set in config');
      throw new Error('JWT_REFRESH_SECRET not configured');
    }

    return this.jwtService.signAsync(
      {
        sub: user.id,
        email: user.email,
      },
      {
        secret,
        expiresIn: '7d',
      },
    );
  }
}
