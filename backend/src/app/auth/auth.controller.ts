import {
  BadRequestException,
  Body,
  Controller,
  HttpCode,
  Post,
  UnauthorizedException,
  UseGuards,
} from '@nestjs/common';
import { PinoLogger } from 'nestjs-pino';
import { AuthService } from './auth.service';
import { RegisterUserDto } from './dto/register-user.dto';
import { LoginUserDto } from './dto/login-user.dto';
import { UsersService } from '../users/users.service';
import { LocalAuthGuard } from './guards/local-auth.guard';
import { ApiBearerAuth, ApiTags, ApiOperation, ApiBody } from '@nestjs/swagger';

@ApiTags('Auth')
@ApiBearerAuth('access-token')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly usersService: UsersService,
    private readonly logger: PinoLogger,
  ) {}

  @Post('register')
  @HttpCode(201)
  @ApiOperation({ summary: 'Register a new user' })
  @ApiBody({ type: RegisterUserDto })
  async register(@Body() registerDto: RegisterUserDto) {
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

  @UseGuards(LocalAuthGuard)
  @Post('login')
  @HttpCode(200)
  @ApiOperation({ summary: 'Login a user' })
  @ApiBody({ type: LoginUserDto })
  async login(@Body() loginDto: LoginUserDto) {
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

    this.logger.info({ userId: user.id }, '✅ User logged in');
    return this.authService.authorize(user);
  }
}
