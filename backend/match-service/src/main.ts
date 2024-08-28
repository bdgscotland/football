import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable CORS for all origins (not recommended for production)
  app.enableCors();

  // Or configure CORS to allow specific origins
  app.enableCors({
    origin: 'http://localhost',
    methods: 'GET,POST,PUT,DELETE',
    allowedHeaders: 'Content-Type, Authorization',
  });

  await app.listen(4001);
}
bootstrap();
