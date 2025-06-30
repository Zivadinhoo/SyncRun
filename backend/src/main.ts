import { NestFactory } from '@nestjs/core';
import { AppModule } from './app/app.module';
import { Logger } from 'nestjs-pino';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import * as cookieParser from 'cookie-parser';
import { seed as seedHalfMarathonNoRest } from './app/seeds/half-marathon-2.seed'; //

async function bootstrap() {
  if (process.argv.includes('--seed-half-2')) {
    await seedHalfMarathonNoRest();
    process.exit(0);
  }
  const app = await NestFactory.create(AppModule, {
    bufferLogs: true,
  });

  app.useLogger(app.get(Logger));
  app.use(cookieParser());

  app.enableCors({
    origin: 'http://localhost:3000',
    credentials: true,
  });

  const config = new DocumentBuilder()
    .setTitle('RunWithCoach API')
    .setDescription('API docs for coaches and athletes')
    .setVersion('1.0')
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        name: 'Authorization',
        in: 'header',
      },
      'access-token',
    )
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('docs', app, document);

  await app.listen(3001, '0.0.0.0');
}
bootstrap();
