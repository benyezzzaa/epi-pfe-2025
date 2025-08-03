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
exports.UsersService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const users_entity_1 = require("./users.entity");
const bcrypt = require("bcryptjs");
const axios_1 = require("axios");
let UsersService = class UsersService {
    userRepository;
    constructor(userRepository) {
        this.userRepository = userRepository;
    }
    async geocodeAdresse(adresse) {
        const res = await axios_1.default.get('https://nominatim.openstreetmap.org/search', {
            params: {
                q: adresse,
                format: 'json',
                limit: 1,
            },
            headers: {
                'User-Agent': 'nestjs-backend-app',
            },
        });
        if (res.data.length === 0) {
            throw new Error("Adresse introuvable");
        }
        return {
            lat: parseFloat(res.data[0].lat),
            lon: parseFloat(res.data[0].lon),
        };
    }
    async createCommercial(createUserDto) {
        const existingUser = await this.userRepository.findOne({
            where: { email: createUserDto.email },
        });
        if (existingUser) {
            throw new common_1.BadRequestException('Email déjà utilisé');
        }
        if (!createUserDto.adresse?.trim()) {
            throw new common_1.BadRequestException('Adresse obligatoire pour géolocaliser le commercial.');
        }
        const salt = await bcrypt.genSalt();
        const hashedPassword = await bcrypt.hash(createUserDto.password, salt);
        let coords;
        try {
            coords = await this.geocodeAdresse(createUserDto.adresse);
        }
        catch (error) {
            throw new common_1.BadRequestException("Adresse invalide ou non trouvée");
        }
        const cleanTel = createUserDto.tel?.replace(/\s+/g, '');
        const commercial = this.userRepository.create({
            ...createUserDto,
            tel: cleanTel,
            password: hashedPassword,
            latitude: coords.lat,
            longitude: coords.lon,
            role: 'commercial',
            isActive: true,
        });
        return await this.userRepository.save(commercial);
    }
    async createAdmin(dto) {
        const existing = await this.userRepository.findOne({ where: { email: dto.email } });
        if (existing)
            throw new common_1.BadRequestException('Email déjà utilisé');
        const salt = await bcrypt.genSalt();
        const hashed = await bcrypt.hash(dto.password, salt);
        const cleanTel = dto.tel?.replace(/\s+/g, '');
        const admin = this.userRepository.create({
            ...dto,
            tel: cleanTel,
            password: hashed,
            role: 'admin',
            isActive: true,
        });
        return this.userRepository.save(admin);
    }
    async findAll() {
        return this.userRepository.find();
    }
    async findByEmail(email) {
        return this.userRepository.findOne({ where: { email } });
    }
    async findByRole(role) {
        return role
            ? this.userRepository.find({ where: { role } })
            : this.userRepository.find();
    }
    async findAllCommerciaux() {
        return this.userRepository.find({
            where: { role: 'commercial' },
            relations: ['visites'],
        });
    }
    async updateUser(id, updateUserDto, currentUser) {
        const user = await this.userRepository.findOneBy({ id });
        if (!user)
            throw new common_1.NotFoundException('Utilisateur non trouvé');
        if (currentUser?.role === 'commercial' && currentUser.id !== id) {
            throw new common_1.BadRequestException("Vous ne pouvez modifier que votre propre profil.");
        }
        if (currentUser?.role === 'commercial' && updateUserDto.role && updateUserDto.role !== user.role) {
            throw new common_1.BadRequestException("Vous ne pouvez pas modifier votre rôle.");
        }
        if (currentUser?.role === 'commercial') {
            delete updateUserDto.password;
        }
        if (updateUserDto.adresse && updateUserDto.adresse !== user.adresse) {
            try {
                const coords = await this.geocodeAdresse(updateUserDto.adresse);
                user.latitude = coords.lat;
                user.longitude = coords.lon;
            }
            catch (error) {
                throw new common_1.BadRequestException("Adresse invalide ou non trouvée");
            }
        }
        if (updateUserDto.tel) {
            updateUserDto.tel = updateUserDto.tel.replace(/\s+/g, '');
        }
        if (updateUserDto.password && (!currentUser || currentUser.role === 'admin')) {
            const salt = await bcrypt.genSalt();
            updateUserDto.password = await bcrypt.hash(updateUserDto.password, salt);
        }
        Object.assign(user, updateUserDto);
        return this.userRepository.save(user);
    }
    async updateStatus(id, isActive) {
        const user = await this.userRepository.findOneBy({ id });
        if (!user)
            throw new common_1.NotFoundException('Utilisateur introuvable');
        user.isActive = isActive;
        return this.userRepository.save(user);
    }
    async updatePassword(email, hashedPassword) {
        const user = await this.userRepository.findOne({ where: { email } });
        if (!user)
            throw new common_1.NotFoundException('Utilisateur introuvable');
        user.password = hashedPassword;
        return this.userRepository.save(user);
    }
    async updatePosition(id, latitude, longitude) {
        const user = await this.userRepository.findOneBy({ id });
        if (!user)
            throw new common_1.NotFoundException(`Utilisateur ${id} introuvable`);
        user.latitude = latitude;
        user.longitude = longitude;
        return this.userRepository.save(user);
    }
    async getAllCommercialsWithPosition() {
        return this.userRepository.find({
            where: { role: 'commercial', isActive: true },
            select: ['id', 'nom', 'prenom', 'latitude', 'longitude'],
        });
    }
    async updateOwnProfile(userId, updateUserDto) {
        console.log('📦 updateUserDto recu :', updateUserDto);
        const user = await this.userRepository.findOneBy({ id: userId });
        if (!user)
            throw new common_1.NotFoundException('Utilisateur non trouvé');
        if (updateUserDto.role && updateUserDto.role !== user.role) {
            throw new common_1.BadRequestException("Vous ne pouvez pas modifier votre rôle.");
        }
        if (updateUserDto.tel) {
            updateUserDto.tel = updateUserDto.tel.replace(/[^\d+]/g, '').replace(/^33/, '0');
        }
        if (updateUserDto.password) {
            const salt = await bcrypt.genSalt();
            updateUserDto.password = await bcrypt.hash(updateUserDto.password, salt);
        }
        Object.assign(user, updateUserDto);
        return this.userRepository.save(user);
    }
};
exports.UsersService = UsersService;
exports.UsersService = UsersService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(users_entity_1.User)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], UsersService);
//# sourceMappingURL=users.service.js.map