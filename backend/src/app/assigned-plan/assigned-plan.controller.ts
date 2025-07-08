import {
  Controller,
  Post,
  Body,
  Get,
  Param,
  Delete,
  Req,
  ParseIntPipe,
  UseGuards,
} from '@nestjs/common';
import { AssignedPlanService } from './assigned-plan.service';
import { CreateAssignedPlanDto } from './dto/create-assigned-plan-dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
} from '@nestjs/swagger';
import { RequestWithUser } from '../common/types/request-with-user';

@ApiTags('Assigned Plans')
@ApiBearerAuth('access-token')
@UseGuards(JwtAuthGuard)
@Controller('assigned-plan')
export class AssignedPlanController {
  constructor(private readonly service: AssignedPlanService) {}

  @Post()
  @ApiOperation({ summary: 'Assign AI training plan to athlete' })
  @ApiResponse({ status: 201 })
  async create(
    @Body() dto: CreateAssignedPlanDto,
    @Req() req: RequestWithUser,
  ) {
    return this.service.create({
      ...dto,
      athleteId: req.user.id,
    });
  }

  @Get('mine')
  @ApiOperation({ summary: 'Get all my assigned plans' })
  async getMyPlans(@Req() req: RequestWithUser) {
    return this.service.findAllByAthlete(req.user.id);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get one assigned plan (must belong to me)' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @Req() req: RequestWithUser,
  ) {
    return this.service.findOne(id, req.user.id);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete assigned plan (soft delete)' })
  async delete(
    @Param('id', ParseIntPipe) id: number,
    @Req() req: RequestWithUser,
  ) {
    return this.service.softDelete(id, req.user.id);
  }
}
