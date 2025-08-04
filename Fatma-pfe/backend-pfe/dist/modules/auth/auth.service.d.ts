import { UsersService } from '../users/users.service';
import { JwtService } from '@nestjs/jwt';
import { LoginUserDto } from '../users/dto/login-user.dto';
import { MailerService } from '@nestjs-modules/mailer';
export declare class AuthService {
    private usersService;
    private jwtService;
    private mailerService;
    constructor(usersService: UsersService, jwtService: JwtService, mailerService: MailerService);
    private resetTokens;
    login(loginUserDto: LoginUserDto): Promise<{
        access_token: string;
        user: {
            id: number;
            nom: string;
            adresse: string;
            prenom: string;
            email: string;
            tel: string;
            role: string;
            latitude: number;
            longitude: number;
            isActive: boolean;
            clients: import("../client/client.entity").Client[];
            visites: import("../Visite/visite.entity").Visite[];
            commandes: import("../commande/commande.entity").Commande[];
        };
    }>;
    forgotPassword(email: string): Promise<{
        message: string;
    }>;
    resetPassword(token: string, newPassword: string): Promise<{
        message: string;
    }>;
}
