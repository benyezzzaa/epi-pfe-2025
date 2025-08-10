"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const core_1 = require("@nestjs/core");
const app_module_1 = require("./app.module");
const swagger_1 = require("@nestjs/swagger");
const express = require("express");
const path_1 = require("path");
const common_1 = require("@nestjs/common");
async function bootstrap() {
    const app = await core_1.NestFactory.create(app_module_1.AppModule);
    app.enableCors({
        origin: true,
        methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
        allowedHeaders: ['Content-Type', 'Authorization', 'Accept', 'Origin', 'X-Requested-With'],
        credentials: true,
        preflightContinue: false,
        optionsSuccessStatus: 204
    });
    app.useGlobalPipes(new common_1.ValidationPipe({
        whitelist: true,
        transform: true,
        forbidNonWhitelisted: true,
        skipNullProperties: true,
        skipUndefinedProperties: true
    }));
    app.use('/uploads', express.static((0, path_1.join)(__dirname, '..', 'uploads')));
    const config = new swagger_1.DocumentBuilder()
        .setTitle('API Backend Commercial')
        .setDescription("Documentation de l’API pour la gestion des commerciaux")
        .setVersion('1.0')
        .addBearerAuth()
        .build();
    const document = swagger_1.SwaggerModule.createDocument(app, config);
    swagger_1.SwaggerModule.setup('api', app, document);
    await app.listen(4000, '0.0.0.0');
    console.log('🚀 Swagger disponible sur http://localhost:5000/api');
}
bootstrap();
//# sourceMappingURL=main.js.map