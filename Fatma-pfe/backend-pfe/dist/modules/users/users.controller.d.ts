import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
export declare class UsersController {
    private usersService;
    constructor(usersService: UsersService);
    createCommercial(createUserDto: CreateUserDto): Promise<import("./users.entity").User>;
    createAdmin(createUserDto: CreateUserDto): Promise<import("./users.entity").User>;
    findUsers(role?: string): Promise<import("./users.entity").User[]>;
    toggleUserStatus(id: number, body: {
        isActive: boolean;
    }): Promise<import("./users.entity").User>;
    updateProfile(req: any, dto: UpdateProfileDto): Promise<import("./users.entity").User>;
    updateUser(id: number, updateUserDto: UpdateUserDto, req: any): Promise<import("./users.entity").User>;
    updatePosition(id: number, body: {
        latitude: number;
        longitude: number;
    }): Promise<import("./users.entity").User>;
    getCommercialsWithPosition(): Promise<import("./users.entity").User[]>;
}
