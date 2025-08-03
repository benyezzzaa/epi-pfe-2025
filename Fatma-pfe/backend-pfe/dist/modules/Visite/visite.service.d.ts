import { Repository } from 'typeorm';
import { Visite } from './visite.entity';
import { CreateVisiteDto } from './dto/create-visite.dto';
import { User } from '../users/users.entity';
import { Client } from '../client/client.entity';
import { RaisonVisite } from '../raison-visite/raison-visite.entity';
export declare class VisiteService {
    private visiteRepository;
    private clientRepository;
    private raisonVisiteRepository;
    constructor(visiteRepository: Repository<Visite>, clientRepository: Repository<Client>, raisonVisiteRepository: Repository<RaisonVisite>);
    createVisite(dto: CreateVisiteDto, user: User): Promise<Visite>;
    getAllVisites(): Promise<Visite[]>;
    getVisitesByCommercial(commercialId: number): Promise<Visite[]>;
    deleteVisite(id: number, user: User): Promise<void>;
}
