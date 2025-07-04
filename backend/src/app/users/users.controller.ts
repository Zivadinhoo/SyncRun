import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Param,
  Body,
  ParseIntPipe,
  UseGuards,
  Req,
} from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { Logger } from 'nestjs-pino';
import {
  ApiTags,
  ApiOperation,
  ApiParam,
  ApiResponse,
  ApiBearerAuth,
  ApiBody,
  ApiOkResponse,
} from '@nestjs/swagger';
import { User, UserRole } from '../entities/user.entity';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { RequestWithUser } from '../common/types/request-with-user';
import { SetActiveAssignedPlanDto } from './dto/set-active-assigned-plan.dto';

@ApiTags('Users')
@ApiBearerAuth('access-token')
@Controller('users')
export class UsersController {
  constructor(
    private readonly usersService: UsersService,
    private readonly logger: Logger,
  ) {}

  @ApiOperation({ summary: 'Get all athletes assigned to the logged-in coach' })
  @ApiOkResponse({ description: 'List of athletes returned successfully.' })
  @UseGuards(JwtAuthGuard)
  @Roles(UserRole.COACH)
  @Get('athletes/my')
  GetMyAthletes(@Req() req: RequestWithUser) {
    const coachId = req.user.id;
    return this.usersService.getMyAthletes(coachId);
  }
  @UseGuards(JwtAuthGuard)
  @Get('me')
  @ApiOperation({ summary: 'Get currently authenticated user' })
  @ApiOkResponse({ type: User })
  getCurrentUser(@Req() req: RequestWithUser) {
    return this.usersService.getMe(req.user.id);
  }

  @Post()
  @ApiOperation({ summary: 'Create a new user ' })
  @ApiBody({ type: CreateUserDto })
  @ApiResponse({
    status: 201,
    description: 'User created successfully',
    type: User,
  })
  async create(@Body() dto: CreateUserDto) {
    try {
      const user = await this.usersService.create(dto);
      this.logger.log(`User created: ${user.email}`);
      return user;
    } catch (error) {
      this.logger.error('Failed to create user', error);
      throw error;
    }
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update user by ID' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: UpdateUserDto })
  @ApiResponse({
    status: 200,
    description: 'User updated successfully',
    type: User,
  })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateUserDto,
  ) {
    try {
      const user = await this.usersService.update(id, dto);
      this.logger.log(`User updated: ID ${user.id}`);
      return user;
    } catch (error) {
      this.logger.error(`Failed to update user ID ${id}`, error);
      throw error;
    }
  }

  @Get()
  @ApiOperation({ summary: 'Get all users' })
  @ApiResponse({ status: 200, description: 'List of users', type: [User] })
  async findAll() {
    try {
      const users = await this.usersService.findAll();
      this.logger.log(`Fetched ${users.length} users`);
      return users;
    } catch (error) {
      this.logger.error('Failed to get users', error);
      throw error;
    }
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get user by ID' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'User found', type: User })
  async findOne(@Param('id', ParseIntPipe) id: number) {
    try {
      const user = await this.usersService.findOne(id);
      this.logger.log(`Fetched user ID ${id}`);
      return user;
    } catch (error) {
      this.logger.error(`Failed to get user ID ${id}`, error);
      throw error;
    }
  }

  @Patch(':id/active-plan')
  @ApiOperation({ summary: 'Set active assigned plan for user' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: SetActiveAssignedPlanDto })
  @UseGuards(JwtAuthGuard)
  @Roles(UserRole.COACH)
  async setActivePlan(
    @Param('id', ParseIntPipe) id: number,
    @Body() body: SetActiveAssignedPlanDto,
  ) {
    try {
      const updatedUser = await this.usersService.setActiveAssignedPlan(
        id,
        body.assignedPlanId,
      );
      this.logger.log(`✅ Active assigned plan set for user ${id}`);
      return updatedUser;
    } catch (error) {
      this.logger.error({ id, error }, '🚨 Failed to set active assigned plan');
      throw error;
    }
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete user by ID' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'User deleted' })
  async remove(@Param('id', ParseIntPipe) id: number) {
    try {
      await this.usersService.remove(id);
      this.logger.log(`Deleted user ID ${id}`);
      return { message: `User ${id} deleted` };
    } catch (error) {
      this.logger.error(`Failed to delete user ID ${id}`, error);
      throw error;
    }
  }
}
