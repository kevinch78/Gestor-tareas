import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));

  app.enableCors({
      origin: (origin, callback) => {
        // permite peticiones sin origin (curl, postman) y locales
        if (!origin) return callback(null, true);

        const allowedOrigins = [
          'https://gestor-tareas-porg.onrender.com', // tu API
          // añade otros dominios que necesites en producción
        ];

        // permitir cualquier localhost:*
        if (origin.startsWith('http://localhost') || origin.startsWith('http://127.0.0.1')) {
          return callback(null, true);
        }

        if (allowedOrigins.indexOf(origin) !== -1) {
          return callback(null, true);
        }

        // rechazo explícito en caso contrario
        return callback(new Error('Not allowed by CORS'));
      },
      methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
      allowedHeaders: 'Content-Type, Authorization',
    });

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
