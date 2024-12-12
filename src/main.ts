import { NestFactory } from '@nestjs/core';
import { AppModule } from '@/app.module';
import { port } from '@/config/env.config';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.setGlobalPrefix('api');
  app.enableCors();
  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
      whitelist: true,
      forbidNonWhitelisted: true,
      skipMissingProperties: true,
      forbidUnknownValues: true,
    }),
  );
  await app.listen(port);
}
bootstrap();
