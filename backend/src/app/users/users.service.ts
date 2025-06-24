import {
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserRole } from '../entities/user.entity';
import { AssignedPlan } from '../entities/assigned-plan.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { PinoLogger } from 'nestjs-pino';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,

    @InjectRepository(AssignedPlan)
    private readonly assignedPlanRepository: Repository<AssignedPlan>,

    private readonly logger: PinoLogger,
  ) {
    this.logger.setContext(UsersService.name);
  }

  async create(createUserDto: CreateUserDto): Promise<User> {
    try {
      const user = this.userRepository.create({
        ...createUserDto,
        coach: createUserDto.coachId
          ? ({ id: createUserDto.coachId } as any)
          : undefined,
      });

      const saved = await this.userRepository.save(user);
      this.logger.info({ userId: saved.id }, '✅ User created');
      return saved;
    } catch (error) {
      this.logger.error(
        { error, dto: createUserDto },
        '🚨 Error while creating user',
      );
      throw new InternalServerErrorException('Failed to create user');
    }
  }

  async checkIfUserWithEmailExists(email: string): Promise<boolean> {
    try {
      const user = await this.userRepository.findOne({ where: { email } });
      return !!user;
    } catch (error) {
      this.logger.error(
        { email, error },
        '🚨 Error while checking user by email',
      );
      throw new InternalServerErrorException('DB error during email check');
    }
  }

  async update(id: number, updateUserDto: UpdateUserDto): Promise<User> {
    try {
      const updateResult = await this.userRepository.update(id, updateUserDto);

      if (updateResult.affected === 0) {
        this.logger.warn(`⚠️ User with ID ${id} not found for update`);
        throw new NotFoundException('User not found');
      }

      const updated = await this.userRepository.findOneByOrFail({ id });
      this.logger.info({ id }, '✅ User updated');
      return updated;
    } catch (error) {
      this.logger.error(
        { id, updateUserDto, error },
        '🚨 Error while updating user',
      );
      throw new InternalServerErrorException('Failed to update user');
    }
  }

  async getMyAthletes(coachId: number): Promise<User[]> {
    try {
      const athletes = await this.userRepository.find({
        where: {
          coach: { id: coachId },
          role: UserRole.ATHLETE,
        },
        relations: ['coach'],
        withDeleted: false,
      });
      return athletes;
    } catch (error) {
      this.logger.error({ coachId, error }, '🚨 Error while fetching athletes');
      throw new InternalServerErrorException('Failed to fetch athletes');
    }
  }

  async findAll(): Promise<User[]> {
    try {
      const users = await this.userRepository.find({ withDeleted: false });
      this.logger.info(`📦 Retrieved ${users.length} users`);
      return users;
    } catch (error) {
      this.logger.error(error, '🚨 Error while fetching all users');
      throw new InternalServerErrorException('Failed to fetch users');
    }
  }

  async findOneBy(where: Partial<User>): Promise<User | null> {
    try {
      const user = await this.userRepository.findOne({ where });
      if (!user) {
        this.logger.warn({ where }, '⚠️ User not found by condition');
      }
      return user;
    } catch (error) {
      this.logger.error({ where, error }, '🚨 Error while finding user');
      throw new InternalServerErrorException('Failed to find user');
    }
  }

  async findOne(id: number): Promise<User> {
    try {
      const user = await this.userRepository.findOneOrFail({ where: { id } });
      this.logger.info({ id }, '🔍 Found user by ID');
      return user;
    } catch (error) {
      this.logger.error({ id, error }, '🚨 User not found by ID');
      throw new NotFoundException('User not found');
    }
  }

  async setActiveAssignedPlan(
    userId: number,
    assignedPlanId: number,
  ): Promise<User> {
    const user = await this.userRepository.findOneBy({ id: userId });
    if (!user) throw new NotFoundException('User not found');

    const assignedPlan = await this.assignedPlanRepository.findOneBy({
      id: assignedPlanId,
    });
    if (!assignedPlan) throw new NotFoundException('Assigned plan not found');

    user.activeAssignedPlan = assignedPlan;
    const saved = await this.userRepository.save(user);
    this.logger.info({ userId, assignedPlan }, '✅ Active plan set for user');

    return saved;
  }

  async remove(id: number): Promise<void> {
    try {
      const user = await this.userRepository.findOneOrFail({ where: { id } });

      if (user.role === UserRole.ATHLETE) {
        await this.assignedPlanRepository
          .createQueryBuilder()
          .softDelete()
          .where('athleteId = :id', { id })
          .execute();
      }

      // Soft delete user
      const result = await this.userRepository.softDelete(id);

      if (result.affected === 0) {
        this.logger.warn(`⚠️ No user found to soft delete with ID ${id}`);
        throw new NotFoundException('User not found for deletion');
      }

      this.logger.info({ id }, '🗑️ User and related data soft deleted');
    } catch (error) {
      this.logger.error({ id, error }, '🚨 Error while deleting user');
      console.error('🔥 DELETE USER CRASH:', error); //
      throw new InternalServerErrorException('Failed to delete user');
    }
  }
}
