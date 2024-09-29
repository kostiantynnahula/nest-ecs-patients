import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { useContainer } from 'class-validator';
import { ConfigService } from '@nestjs/config';
import { ValidationPipe } from '@nestjs/common';
import { Transport } from '@nestjs/microservices';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const configService = app.get(ConfigService);

  useContainer(app.select(AppModule), { fallbackOnErrors: true });

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidUnknownValues: true,
      skipMissingProperties: true,
      validationError: {
        target: true,
        value: true,
      },
    }),
  );

  app.connectMicroservice({
    transport: Transport.TCP,
    options: {
      host: '0.0.0.0',
      port: configService.get('TCP'),
    },
  });

  const config = new DocumentBuilder()
    .setTitle('Patient API')
    .setDescription('The Patient API description')
    .setVersion('0.1')
    .build();

  app.setGlobalPrefix('patient');

  const document = SwaggerModule.createDocument(app, config, {});

  SwaggerModule.setup('api', app, document, {
    useGlobalPrefix: true,
  });

  await app.startAllMicroservices();

  await app.listen(configService.get<number>('PORT') || 3000);
}
bootstrap();
