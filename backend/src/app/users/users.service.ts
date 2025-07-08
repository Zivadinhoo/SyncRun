import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { SetActiveAssignedPlanDto } from './dto/set-active-assigned-plan.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  /**
   * Create new user
   */
  async create(createUserDto: CreateUserDto): Promise<User> {
    const user = this.userRepository.create(createUserDto);
    return this.userRepository.save(user);
  }

  /**
   * Get all users
   */
  async findAll(): Promise<User[]> {
    return this.userRepository.find();
  }

  /**
   * Find user by email
   */
  async findOneByEmail(email: string): Promise<User | null> {
    return this.userRepository.findOne({ where: { email } });
  }

  /**
   * Check if user with given email exists
   */
  async checkIfUserWithEmailExists(email: string): Promise<boolean> {
    const user = await this.findOneByEmail(email);
    return !!user;
  }

  /**
   * Find user by ID
   */
  async findOne(id: number): Promise<User> {
    const user = await this.userRepository.findOne({ where: { id } });
    if (!user) throw new NotFoundException(`User with ID ${id} not found`);
    return user;
  }

  /**
   * Update user
   */
  async update(id: number, updateUserDto: UpdateUserDto): Promise<User> {
    const user = await this.findOne(id);
    Object.assign(user, updateUserDto);
    return this.userRepository.save(user);
  }

  /**
   * Delete user
   */
  async remove(id: number): Promise<void> {
    await this.userRepository.delete(id);
  }

  /**
   * Set active assigned training plan
   */
  async setActiveAssignedPlan(
    userId: number,
    dto: SetActiveAssignedPlanDto,
  ): Promise<User> {
    const user = await this.findOne(userId);
    user.activeAssignedPlanId = dto.assignedPlanId;
    return this.userRepository.save(user);
  }
}
