import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

/**
 * Guard for handling refresh token authentication.
 */
@Injectable()
export class RefreshJwtAuthGuard extends AuthGuard('jwt-refresh-token') {}
