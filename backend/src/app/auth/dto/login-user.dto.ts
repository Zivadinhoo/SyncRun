import { IsEmail, MinLength, MaxLength } from 'class-validator';

export class LoginUserDto {
  @IsEmail({}, { message: 'Email should be in a valid email format.' })
  email!: string;

  @MinLength(6, {
    message: (args) =>
      `Password is too short. Minimum length is ${args.constraints[0]} characters.`,
  })
  @MaxLength(20, {
    message: (args) =>
      `Password is too long. Maximum length is ${args.constraints[0]} characters.`,
  })
  password!: string;
}
