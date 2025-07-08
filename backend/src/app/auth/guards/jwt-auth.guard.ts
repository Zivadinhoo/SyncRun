import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

/**
 * Guard for protecting routes with access token.
 */
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
