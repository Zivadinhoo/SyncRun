import {
  IsNotEmpty,
  MinLength,
  MaxLength,
  IsEmail,
  IsAlpha,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class RegisterUserDto {
  @ApiProperty({ example: 'runner@example.com', description: 'User email' })
  @IsEmail({}, { message: 'Email should be in a valid email format.' })
  email!: string;

  @ApiProperty({
    example: 'mySecret123',
    description: 'Password (6-20 characters)',
    minLength: 6,
    maxLength: 20,
  })
  @MinLength(6, {
    message: ({ constraints }) =>
      `Password is too short. Minimum length is ${constraints[0]} characters.`,
  })
  @MaxLength(20, {
    message: ({ constraints }) =>
      `Password is too long. Maximum length is ${constraints[0]} characters.`,
  })
  password!: string;

  @ApiProperty({ example: 'John', description: 'First name' })
  @IsNotEmpty({ message: 'First name is required.' })
  @IsAlpha(undefined, { message: 'First name must contain only letters.' })
  firstName!: string;

  @ApiProperty({ example: 'Doe', description: 'Last name' })
  @IsNotEmpty({ message: 'Last name is required.' })
  @IsAlpha(undefined, { message: 'Last name must contain only letters.' })
  lastName!: string;
}
