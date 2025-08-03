import { Repository } from 'typeorm';
import { ObjectifCommercial } from './objectif-commercial.entity';
import { User } from '../users/users.entity';
import { CreateObjectifDto, CreateObjectifGlobalDto } from './DTO/create-objectif.dto';
import { Commande } from '../commande/commande.entity';
export declare class ObjectifCommercialService {
    private objectifRepo;
    private userRepo;
    private commandeRepo;
    constructor(objectifRepo: Repository<ObjectifCommercial>, userRepo: Repository<User>, commandeRepo: Repository<Commande>);
    create(dto: CreateObjectifDto): Promise<ObjectifCommercial>;
    createGlobal(createDto: CreateObjectifGlobalDto): Promise<ObjectifCommercial>;
    findAll(): Promise<any[]>;
    toggleStatus(id: number): Promise<ObjectifCommercial>;
    getGlobalMontantProgress(): Promise<any[]>;
    getByCommercialGroupedByYear(userId: number): Promise<Record<number, ObjectifCommercial[]>>;
    getSalesByCategory(userId: number): Promise<any[]>;
    getProgressForAdmin(): Promise<{
        id: number;
        commercial: User;
        categorie: string | null;
        objectif: number | null;
        realise: number;
        atteint: boolean;
    }[]>;
    getObjectifsProgress(userId: number): Promise<{
        id: number;
        mission: string | undefined;
        dateDebut: Date;
        dateFin: Date;
        prime: number;
        ventes: number;
        montantCible: number;
        atteint: boolean;
        isGlobal: boolean;
    }[]>;
    update(id: number, updateData: Partial<ObjectifCommercial>): Promise<ObjectifCommercial>;
    remove(id: number): Promise<ObjectifCommercial>;
}
