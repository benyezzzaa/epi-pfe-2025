import { Repository } from 'typeorm';
import { User } from './users.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
export declare class UsersService {
    private userRepository;
    constructor(userRepository: Repository<User>);
    private geocodeAdresse;
    createCommercial(createUserDto: CreateUserDto): Promise<User>;
    createAdmin(dto: CreateUserDto): Promise<User>;
    findAll(): Promise<User[]>;
    findByEmail(email: string): Promise<User | null>;
    findByRole(role?: string): Promise<User[]>;
    findAllCommerciaux(): Promise<User[]>;
    updateUser(id: number, updateUserDto: UpdateUserDto, currentUser?: any): Promise<User>;
    updateStatus(id: number, isActive: boolean): Promise<User>;
    updatePassword(email: string, hashedPassword: string): Promise<User>;
    updatePosition(id: number, latitude: number, longitude: number): Promise<User>;
    getAllCommercialsWithPosition(): Promise<User[]>;
    updateOwnProfile(userId: number, updateUserDto: UpdateProfileDto): Promise<User>;
}
