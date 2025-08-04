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
exports.AuthService = void 0;
const common_1 = require("@nestjs/common");
const users_service_1 = require("../users/users.service");
const jwt_1 = require("@nestjs/jwt");
const mailer_1 = require("@nestjs-modules/mailer");
const bcrypt = require("bcryptjs");
const uuid_1 = require("uuid");
let AuthService = class AuthService {
    usersService;
    jwtService;
    mailerService;
    constructor(usersService, jwtService, mailerService) {
        this.usersService = usersService;
        this.jwtService = jwtService;
        this.mailerService = mailerService;
    }
    resetTokens = new Map();
    async login(loginUserDto) {
        const { email, password } = loginUserDto;
        const user = await this.usersService.findByEmail(email);
        if (!user || !(await bcrypt.compare(password, user.password))) {
            throw new common_1.UnauthorizedException('Email ou mot de passe incorrect');
        }
        if (!user.isActive) {
            throw new common_1.UnauthorizedException('Votre compte est désactivé. Veuillez contacter un administrateur.');
        }
        const payload = {
            id: user.id,
            email: user.email,
            role: user.role,
        };
        const token = this.jwtService.sign(payload);
        const { password: _, ...userWithoutPassword } = user;
        return {
            access_token: token,
            user: userWithoutPassword,
        };
    }
    async forgotPassword(email) {
        if (!email || typeof email !== 'string' || !email.includes('@')) {
            throw new common_1.BadRequestException('Adresse email invalide');
        }
        const user = await this.usersService.findByEmail(email);
        if (!user) {
            throw new common_1.NotFoundException('Aucun utilisateur associé à cet email.');
        }
        const token = (0, uuid_1.v4)();
        this.resetTokens.set(token, email);
        const resetLink = `http://localhost:3000/reset-password?token=${token}`;
        await this.mailerService.sendMail({
            to: email,
            subject: 'Réinitialisation de votre mot de passe',
            html: `
        <h2>Demande de réinitialisation de mot de passe</h2>
        <p>Bonjour ${user.prenom || ''},</p>
        <p>Vous avez demandé à réinitialiser votre mot de passe. Cliquez sur le lien ci-dessous :</p>
        <a href="${resetLink}">${resetLink}</a>
        <p>Si vous n’êtes pas à l’origine de cette demande, ignorez cet email.</p>
      `,
        });
        return {
            message: 'Un lien de réinitialisation a été envoyé à votre adresse email.',
        };
    }
    async resetPassword(token, newPassword) {
        const email = this.resetTokens.get(token);
        if (!email) {
            throw new common_1.BadRequestException('Token invalide ou expiré');
        }
        const user = await this.usersService.findByEmail(email);
        if (!user) {
            throw new common_1.NotFoundException('Utilisateur introuvable');
        }
        const hashedPassword = await bcrypt.hash(newPassword, 10);
        await this.usersService.updatePassword(email, hashedPassword);
        this.resetTokens.delete(token);
        return {
            message: 'Mot de passe réinitialisé avec succès',
        };
    }
};
exports.AuthService = AuthService;
exports.AuthService = AuthService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [users_service_1.UsersService,
        jwt_1.JwtService,
        mailer_1.MailerService])
], AuthService);
//# sourceMappingURL=auth.service.js.map