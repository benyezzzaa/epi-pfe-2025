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
exports.UsersController = void 0;
const common_1 = require("@nestjs/common");
const users_service_1 = require("./users.service");
const create_user_dto_1 = require("./dto/create-user.dto");
const update_user_dto_1 = require("./dto/update-user.dto");
const swagger_1 = require("@nestjs/swagger");
const jwt_auth_guard_1 = require("../auth/jwt-auth.guard");
const roles_guard_1 = require("../auth/roles.guard");
const setRoles_decorator_1 = require("../auth/setRoles.decorator");
const update_profile_dto_1 = require("./dto/update-profile.dto");
let UsersController = class UsersController {
    usersService;
    constructor(usersService) {
        this.usersService = usersService;
    }
    createCommercial(createUserDto) {
        return this.usersService.createCommercial(createUserDto);
    }
    createAdmin(createUserDto) {
        return this.usersService.createAdmin(createUserDto);
    }
    findUsers(role) {
        return this.usersService.findByRole(role);
    }
    toggleUserStatus(id, body) {
        return this.usersService.updateStatus(id, body.isActive);
    }
    async updateProfile(req, dto) {
        if (!dto.password && !dto.tel) {
            throw new common_1.BadRequestException('Aucune donnée à mettre à jour');
        }
        if (dto.tel === null || dto.tel === undefined) {
            delete dto.tel;
        }
        if (dto.password === null || dto.password === undefined) {
            delete dto.password;
        }
        return this.usersService.updateOwnProfile(req.user.id, dto);
    }
    async updateUser(id, updateUserDto, req) {
        return this.usersService.updateUser(id, updateUserDto, req.user);
    }
    updatePosition(id, body) {
        return this.usersService.updatePosition(id, body.latitude, body.longitude);
    }
    getCommercialsWithPosition() {
        return this.usersService.getAllCommercialsWithPosition();
    }
};
exports.UsersController = UsersController;
__decorate([
    (0, common_1.Post)('create-commercial'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Créer un commercial' }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_user_dto_1.CreateUserDto]),
    __metadata("design:returntype", void 0)
], UsersController.prototype, "createCommercial", null);
__decorate([
    (0, common_1.Post)('create-admin'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Créer un administrateur' }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_user_dto_1.CreateUserDto]),
    __metadata("design:returntype", void 0)
], UsersController.prototype, "createAdmin", null);
__decorate([
    (0, common_1.Get)(),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Lister les utilisateurs (avec filtre par rôle)' }),
    __param(0, (0, common_1.Query)('role')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], UsersController.prototype, "findUsers", null);
__decorate([
    (0, common_1.Put)(':id/status'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Activer ou désactiver un utilisateur' }),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, Object]),
    __metadata("design:returntype", void 0)
], UsersController.prototype, "toggleUserStatus", null);
__decorate([
    (0, common_1.Put)('profile'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Modifier son propre profil (mot de passe/téléphone)' }),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, update_profile_dto_1.UpdateProfileDto]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "updateProfile", null);
__decorate([
    (0, common_1.Put)(':id'),
    (0, setRoles_decorator_1.SetRoles)('admin', 'commercial'),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __param(1, (0, common_1.Body)()),
    __param(2, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, update_user_dto_1.UpdateUserDto, Object]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "updateUser", null);
__decorate([
    (0, common_1.Patch)(':id/position'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Mettre à jour la position d\'un commercial' }),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, Object]),
    __metadata("design:returntype", void 0)
], UsersController.prototype, "updatePosition", null);
__decorate([
    (0, common_1.Get)('commercials/map'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Obtenir la position de tous les commerciaux' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], UsersController.prototype, "getCommercialsWithPosition", null);
exports.UsersController = UsersController = __decorate([
    (0, swagger_1.ApiTags)('Users'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.Controller)('users'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [users_service_1.UsersService])
], UsersController);
//# sourceMappingURL=users.controller.js.map