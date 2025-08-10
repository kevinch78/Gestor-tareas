import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));

  // Swagger config
  const config = new DocumentBuilder()
    .setTitle('Gestor de Tareas API')
    .setDescription('Documentación de la API de la prueba técnica')
    .setVersion('1.0')
    .addBearerAuth()
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('docs', app, document);

  await app.listen(process.env.PORT || 3000, '0.0.0.0');
  console.log(`Server running on http://localhost:${process.env.PORT || 3000}`);
  console.log(`Swagger docs on http://localhost:${process.env.PORT || 3000}/docs`);
}
bootstrap();
