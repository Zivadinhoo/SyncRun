export interface AuthResponse {
  accessToken: string;
  refreshToken: string;
  userId: number;
  email: string;
  fullName?: string;
}
