import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromExtractors([
        // 👇 Prvo pokušaj preko Authorization headera
        ExtractJwt.fromAuthHeaderAsBearerToken(),

        // 👇 Ako nema, pokušaj preko cookie-a (korisno za web)
        (req) => req?.cookies?.access_token || null,
      ]),
      ignoreExpiration: false,
      secretOrKey: configService.get<string>('JWT_SECRET'),
    });
  }

  async validate(payload: any) {
    if (!payload?.sub || !payload?.email) {
      throw new Error('Invalid access token');
    }

    return {
      userId: payload.sub,
      email: payload.email,
    };
  }
}
