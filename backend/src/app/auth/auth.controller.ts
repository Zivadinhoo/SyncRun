import {
  BadRequestException,
  Body,
  Controller,
  HttpCode,
  Post,
  Req,
  Res,
  UnauthorizedException,
  UseGuards,
} from '@nestjs/common';
import { Response } from 'express';
import { PinoLogger } from 'nestjs-pino';
import { ApiBearerAuth, ApiTags, ApiOperation, ApiBody } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { UsersService } from '../users/users.service';
import { RegisterUserDto } from './dto/register-user.dto';
import { LoginUserDto } from './dto/login-user.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { RequestWithUser } from '../common/types/request-with-user';

@ApiTags('Auth')
@ApiBearerAuth('access-token')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly usersService: UsersService,
    private readonly logger: PinoLogger,
  ) {}

  @UseGuards(JwtAuthGuard)
  @Post('register')
  @HttpCode(201)
  @ApiOperation({ summary: 'Register a new user' })
  @ApiBody({ type: RegisterUserDto })
  async register(
    @Body() registerDto: RegisterUserDto,
    @Req() req: RequestWithUser,
  ) {
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
      coachId: req.user.id,
    });

    this.logger.info({ userId: user.id }, '✅ User registered');
    return this.authService.authorize(user);
  }

  @Post('login')
  @HttpCode(200)
  @ApiOperation({ summary: 'Login a user' })
  @ApiBody({ type: LoginUserDto })
  async login(
    @Body() loginDto: LoginUserDto,
    @Res({ passthrough: true }) res: Response,
  ) {
    this.logger.info({ email: loginDto.email }, '🔐 Login request');

    const user = await this.usersService.findOneBy({ email: loginDto.email });

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

    // ✅ Cookie for browser-based clients (optional)
    res.cookie('access_token', accessToken, {
      httpOnly: true,
      sameSite: 'lax',
      secure: false, // set to true in production with HTTPS
      maxAge: 3600 * 1000, // 1 hour
    });

    this.logger.info({ userId: user.id }, '✅ User logged in');

    // ✅ Return tokens and user data for mobile or Flutter
    return {
      ...rest,
      accessToken,
      refreshToken,
    };
  }
}
