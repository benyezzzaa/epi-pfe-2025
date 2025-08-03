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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CircuitService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const circuit_entity_1 = require("./circuit.entity");
const client_entity_1 = require("../client/client.entity");
let CircuitService = class CircuitService {
    circuitRepo;
    clientRepo;
    constructor(circuitRepo, clientRepo) {
        this.circuitRepo = circuitRepo;
        this.clientRepo = clientRepo;
    }
    async getTodayCircuit(user) {
        const dateStr = new Date().toISOString().split('T')[0];
        return this.getCircuitByDate(user, dateStr);
    }
    async create(dto, user) {
        if (!dto.clientIds || dto.clientIds.length === 0) {
            throw new common_1.NotFoundException('Aucun client sélectionné pour le circuit');
        }
        const existing = await this.getCircuitByDate(user, dto.date);
        if (existing) {
            throw new common_1.NotFoundException('Un circuit existe déjà pour cette date');
        }
        const clients = await this.clientRepo.findBy({ id: (0, typeorm_2.In)(dto.clientIds) });
        const clientsWithGPS = clients.filter(c => c.latitude != null && c.longitude != null);
        if (clientsWithGPS.length === 0) {
            throw new common_1.NotFoundException('Aucun client valide avec position GPS');
        }
        const circuit = this.circuitRepo.create({
            date: new Date(dto.date),
            clients: clientsWithGPS,
            commercial: user,
        });
        return this.circuitRepo.save(circuit);
    }
    async findAll() {
        return this.circuitRepo.find({
            relations: ['clients'],
        });
    }
    async getCircuitByDate(user, date) {
        return this.circuitRepo.findOne({
            where: {
                commercial: { id: user.id },
                date: new Date(date),
            },
        });
    }
};
exports.CircuitService = CircuitService;
exports.CircuitService = CircuitService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(circuit_entity_1.Circuit)),
    __param(1, (0, typeorm_1.InjectRepository)(client_entity_1.Client)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository])
], CircuitService);
//# sourceMappingURL=circuit.service.js.map