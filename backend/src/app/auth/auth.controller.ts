import {
  BadRequestException,
  Body,
  Controller,
  HttpCode,
  Post,
  Res,
  UnauthorizedException,
} from '@nestjs/common';
import { Response } from 'express';
import { PinoLogger } from 'nestjs-pino';
import {
  ApiBearerAuth,
  ApiTags,
  ApiOperation,
  ApiBody,
  ApiResponse,
} from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { UsersService } from '../users/users.service';
import { RegisterUserDto } from './dto/register-user.dto';
import { LoginUserDto } from './dto/login-user.dto';
import { AuthResponse } from './interfaces/auth-response.interface';

@ApiTags('Auth')
@ApiBearerAuth('access-token')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly usersService: UsersService,
    private readonly logger: PinoLogger,
  ) {
    this.logger.setContext(AuthController.name);
  }

  @Post('register')
  @HttpCode(201)
  @ApiOperation({ summary: 'Register a new user' })
  @ApiBody({ type: RegisterUserDto })
  @ApiResponse({ status: 201, description: 'User registered' })
  @ApiResponse({ status: 400, description: 'User already exists' })
  async register(@Body() registerDto: RegisterUserDto): Promise<AuthResponse> {
    this.logger.info({ email: registerDto.email }, '📩 Register request');

    const userExists = await this.usersService.checkIfUserWithEmailExists(
      registerDto.email,
    );

    if (userExists) {
      this.logger.warn({ email: registerDto.email }, '⚠️ User already exists');
      throw new BadRequestException('User with this email already exists');
    }

    const hashedPassword = await this.authService.generateHashedPassword(
      registerDto.password,
    );

    const user = await this.usersService.create({
      ...registerDto,
      password: hashedPassword,
    });

    this.logger.info({ userId: user.id }, '✅ User registered');

    return this.authService.authorize(user);
  }

  @Post('login')
  @HttpCode(200)
  @ApiOperation({ summary: 'Login a user' })
  @ApiBody({ type: LoginUserDto })
  @ApiResponse({ status: 200, description: 'User authenticated' })
  @ApiResponse({ status: 401, description: 'Invalid credentials' })
  async login(
    @Body() loginDto: LoginUserDto,
    @Res({ passthrough: true }) res: Response,
  ): Promise<AuthResponse> {
    this.logger.info({ email: loginDto.email }, '🔐 Login request');

    const user = await this.usersService.findOneByEmail(loginDto.email);

    if (!user) {
      this.logger.warn({ email: loginDto.email }, '⚠️ User not found');
      throw new UnauthorizedException('Invalid credentials');
    }

    const isValid = await this.authService.isPasswordValid(
      loginDto.password,
      user.password,
    );

    if (!isValid) {
      this.logger.warn({ email: loginDto.email }, '❌ Invalid password');
      throw new UnauthorizedException('Invalid credentials');
    }

    const { accessToken, refreshToken, ...rest } =
      await this.authService.authorize(user);

    res.cookie('access_token', accessToken, {
      httpOnly: true,
      sameSite: 'lax',
      secure: false, // set to true in production with HTTPS
      maxAge: 3600 * 1000,
    });

    this.logger.info({ userId: user.id }, '✅ User logged in');

    return {
      ...rest,
      accessToken,
      refreshToken,
    };
  }
}
