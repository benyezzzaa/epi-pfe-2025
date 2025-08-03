"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ReglementFactureController = void 0;
const common_1 = require("@nestjs/common");
const reglement_facture_service_1 = require("./reglement-facture.service");
const swagger_1 = require("@nestjs/swagger");
let ReglementFactureController = class ReglementFactureController {
    reglementFactureService;
    constructor(reglementFactureService) {
        this.reglementFactureService = reglementFactureService;
    }
    findAll() {
        return this.reglementFactureService.findAll();
    }
};
exports.ReglementFactureController = ReglementFactureController;
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], ReglementFactureController.prototype, "findAll", null);
exports.ReglementFactureController = ReglementFactureController = __decorate([
    (0, swagger_1.ApiTags)('ReglementFacture'),
    (0, common_1.Controller)('reglement-facture'),
    __metadata("design:paramtypes", [reglement_facture_service_1.ReglementFactureService])
], ReglementFactureController);
//# sourceMappingURL=reglement-facture.controller.js.map