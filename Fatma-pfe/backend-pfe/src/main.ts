import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import * as express from 'express';
import { join } from 'path';
import { ValidationPipe } from '@nestjs/common';
import { json } from 'express';
async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // ✅ CORS pour développement et production
  app.enableCors({
    origin: true, // Permet toutes les origines en développement
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Accept', 'Origin', 'X-Requested-With'],
    credentials: true,
    preflightContinue: false,
    optionsSuccessStatus: 204
  });



  // ✅ Pipes de validation
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
      skipNullProperties: true,           // ✅ << Ajoute ceci
      skipUndefinedProperties: true
    })
  );

  // ✅ Fichiers statiques pour les images de produits
  app.use('/uploads', express.static(join(__dirname, '..', 'uploads')));

  // ✅ Swagger
  const config = new DocumentBuilder()
    .setTitle('API Backend Commercial')
    .setDescription("Documentation de l’API pour la gestion des commerciaux")
    .setVersion('1.0')
    .addBearerAuth()
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  await app.listen(4000, '0.0.0.0');
  
  console.log('🚀 Swagger disponible sur http://localhost:5000/api');
}

bootstrap();
