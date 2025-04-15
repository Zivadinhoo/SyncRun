import { UserRole } from '../../entities/user.entity';

export interface AuthResponse {
  accessToken: string;
  refreshToken: string;
  userId: number;
  email: string;
  role: UserRole;
  fullName?: string;
}
