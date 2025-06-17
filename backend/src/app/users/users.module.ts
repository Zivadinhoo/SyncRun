import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from 'src/app/entities/user.entity';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { AssignedPlan } from '../entities/assigned-plan.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User, AssignedPlan])],
  providers: [UsersService],
  controllers: [UsersController],
  exports: [UsersService],
})
export class UsersModule {}
