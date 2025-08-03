import { Repository } from 'typeorm';
import { Reclamation } from './reclamation.entity';
import { CreateReclamationDto } from './DTO/create-reclamation.dto';
import { Client } from '../client/client.entity';
import { User } from '../users/users.entity';
export declare class ReclamationService {
    private repo;
    private clientRepo;
    constructor(repo: Repository<Reclamation>, clientRepo: Repository<Client>);
    create(dto: CreateReclamationDto, user: User): Promise<Reclamation>;
    findAll(): Promise<Reclamation[]>;
    findByUser(userId: number): Promise<Reclamation[]>;
    findOpenReclamations(): Promise<Reclamation[]>;
    findOpen(): Promise<Reclamation[]>;
    updateStatus(id: number, status: string): Promise<Reclamation>;
}
