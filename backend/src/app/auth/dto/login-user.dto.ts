import { IsEmail, MinLength, MaxLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class LoginUserDto {
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
}
