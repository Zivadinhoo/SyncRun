import {
  IsNotEmpty,
  MinLength,
  MaxLength,
  IsEmail,
  IsAlpha,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class RegisterUserDto {
  @ApiProperty({ example: 'john.doe@example.com', description: 'User email' })
  @IsEmail({}, { message: 'Email should be in a valid email format.' })
  email!: string;

  @ApiProperty({
    example: 'secretPassword',
    description: 'User password (6-20 characters)',
    minLength: 6,
    maxLength: 20,
  })
  @MinLength(6, {
    message: (args) =>
      `Password is too short. Minimum length is ${args.constraints[0]} characters.`,
  })
  @MaxLength(20, {
    message: (args) =>
      `Password is too long. Maximum length is ${args.constraints[0]} characters.`,
  })
  password!: string;

  @ApiProperty({ example: 'John', description: 'First name of the user' })
  @IsNotEmpty({ message: 'First name should not be empty.' })
  @IsAlpha()
  firstName!: string;

  @ApiProperty({ example: 'Doe', description: 'Last name of the user' })
  @IsNotEmpty({ message: 'Last name should not be empty.' })
  @IsAlpha()
  lastName!: string;
}
