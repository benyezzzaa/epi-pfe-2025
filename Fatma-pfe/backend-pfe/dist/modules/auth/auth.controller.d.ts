import { AuthService } from './auth.service';
import { LoginUserDto } from '../users/dto/login-user.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
export declare class AuthController {
    private authService;
    constructor(authService: AuthService);
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
    forgotPassword(dto: ForgotPasswordDto): Promise<{
        message: string;
    }>;
    resetPassword(dto: ResetPasswordDto): Promise<{
        message: string;
    }>;
}
