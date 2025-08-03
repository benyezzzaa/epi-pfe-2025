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
        user: import("../users/users.entity").User;
    }>;
    forgotPassword(email: string): Promise<{
        message: string;
    }>;
    resetPassword(token: string, newPassword: string): Promise<{
        message: string;
    }>;
}
