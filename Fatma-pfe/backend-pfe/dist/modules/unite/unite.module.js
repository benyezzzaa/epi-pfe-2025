"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UniteModule = void 0;
const common_1 = require("@nestjs/common");
const unite_service_1 = require("./unite.service");
const unite_controller_1 = require("./unite.controller");
const typeorm_1 = require("@nestjs/typeorm");
const unite_entity_1 = require("./unite.entity");
let UniteModule = class UniteModule {
};
exports.UniteModule = UniteModule;
exports.UniteModule = UniteModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([unite_entity_1.Unite])],
        controllers: [unite_controller_1.UniteController],
        providers: [unite_service_1.UniteService],
    })
], UniteModule);
//# sourceMappingURL=unite.module.js.map