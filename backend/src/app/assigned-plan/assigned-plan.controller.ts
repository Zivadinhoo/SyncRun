import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { AssignedPlanService } from './assigned-plan.service';
import { CreateAssignedPlanDto } from './dto/create-assigned-plan-dto';
import { UpdateAssignedPlanDto } from './dto/update-assigned-plan.dto';
import { PinoLogger } from 'nestjs-pino';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RoleAuthGuard } from '../auth/guards/role-auth.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { UserRole } from '../entities/user.entity';
import {
  ApiBearerAuth,
  ApiTags,
  ApiOperation,
  ApiResponse,
} from '@nestjs/swagger';
import { error } from 'console';
import { RequestWithUser } from '../common/types/request-with-user';

@ApiTags()
@ApiBearerAuth('access-token')
@UseGuards(JwtAuthGuard, RoleAuthGuard)
@Controller('assigned-plan')
export class AssignedPlanController {
  constructor(
    private readonly service: AssignedPlanService,
    private readonly logger: PinoLogger,
  ) {
    this.logger.setContext(AssignedPlanController.name);
  }

  @Post()
  @Roles(UserRole.COACH)
  @ApiOperation({ summary: 'Assign training plan to athlete (Coach only)' })
  @ApiResponse({ status: 201, description: 'Assigned plan created' })
  async create(@Body() dto: CreateAssignedPlanDto) {
    try {
      const result = await this.service.create(dto);
      this.logger.info(
        `Plan ${dto.trainingPlanId} assigned to athlete ${dto.athleteId}`,
      );
      return result;
    } catch (error) {
      this.logger.error({ err: error, dto }, 'Failed to assign training plan');
      throw error;
    }
  }

  @Post('from-template/:templateId')
  @Roles(UserRole.COACH)
  @ApiOperation({ summary: 'Assign training plan from template to athlete' })
  @ApiResponse({
    status: 201,
    description: 'Assigned plan created from template',
  })
  async assignFromTemplate(
    @Param('templateId') templateId: string,
    @Body() body: { athleteId: number; startDate: string },
    @Req() req: RequestWithUser,
  ) {
    try {
      const result = await this.service.assignFromTemplate(
        templateId,
        body.athleteId,
        new Date(body.startDate),
        req.user.id,
      );
      this.logger.info(
        `Template ${templateId} assigned to athlete ${body.athleteId}`,
      );
      return result;
    } catch (error) {
      this.logger.error({ err: error }, '❌ Failed to assign template');
      throw error;
    }
  }

  @Get('my')
  @Roles(UserRole.COACH)
  @ApiOperation({
    summary: 'Get assigned plans for plans created by logged in coach',
  })
  async getAssignedPlansByCoach(@Req() req: RequestWithUser) {
    try {
      const plans = await this.service.findAllByCoach(req.user.id);
      this.logger.debug(
        `Fetched ${plans.length} assigned plans for coach ${req.user.id}`,
      );
      return plans;
    } catch (error) {
      this.logger.error({ err: error }, '❌ Failed to fetch assigned plans');
      throw error;
    }
  }

  // @UseGuards(JwtAuthGuard, RoleAuthGuard)
  // @Roles(UserRole.ATHLETE)
  @Get('mine')
  @ApiOperation({
    summary: 'Get assigned plans for logged in athlete',
  })
  async getMyPlans(@Req() req: RequestWithUser) {
    const plans = await this.service.findAllByAthlete(req.user.id);
    this.logger.debug(
      `Fetched ${plans.length} plans for athlete ${req.user.id}`,
    );
    return plans;
  }

  @Get()
  @Roles(UserRole.COACH)
  @ApiOperation({ summary: 'Get assigned plan by ID' })
  async findOne(@Param('id', ParseIntPipe) id: number) {
    try {
      const result = await this.service.findOne(id);
      this.logger.debug(`Fetched assigned plan ${id}`);
      return result;
    } catch (error) {
      this.logger.error({ err: error, id }, 'Failed to fetch plan');
    }
    throw error;
  }

  @Patch(':id')
  @HttpCode(200)
  @ApiOperation({ summary: 'Update assigned plan' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateAssignedPlanDto,
  ) {
    try {
      const result = await this.service.update(id, dto);
      this.logger.info(`Updated assigned plan ${id}`);
      return result;
    } catch (error) {
      this.logger.error({ err: error, id, dto }, 'Failed to update a plan');
    }
    throw error;
  }

  @Delete(':id')
  @HttpCode(204)
  @ApiOperation({ summary: 'Soft delete a plan' })
  async softDelete(@Param('id', ParseIntPipe) id: number) {
    try {
      await this.service.softDelete(id);
      this.logger.info(`Soft deleted assigned plan ${id}`);
    } catch (error) {
      this.logger.error({ err: error, id }, 'Failed to soft delete');
    }
    throw error;
  }
}
