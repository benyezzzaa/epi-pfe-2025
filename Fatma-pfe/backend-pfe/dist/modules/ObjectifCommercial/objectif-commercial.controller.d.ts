import { ObjectifCommercialService } from './objectif-commercial.service';
import { CreateObjectifDto, CreateObjectifGlobalDto } from './DTO/create-objectif.dto';
import { ObjectifCommercial } from './objectif-commercial.entity';
export declare class ObjectifCommercialController {
    private readonly objectifService;
    constructor(objectifService: ObjectifCommercialService);
    createObjectifGlobal(dto: CreateObjectifGlobalDto): Promise<ObjectifCommercial>;
    create(dto: CreateObjectifDto): Promise<ObjectifCommercial>;
    findAll(): Promise<any[]>;
    getGlobalProgress(): Promise<{
        id: number;
        commercial: import("../users/users.entity").User;
        categorie: string | null;
        objectif: number | null;
        realise: number;
        atteint: boolean;
    }[]>;
    getGlobalMontantProgress(): Promise<any[]>;
    getMyProgress(req: any): Promise<{
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
    debugAll(req: any): Promise<any[]>;
    debugMyObjectifs(req: any): Promise<{
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
    getMySalesByCategory(req: any): Promise<any[]>;
    getMyObjectifs(req: any): Promise<Record<number, ObjectifCommercial[]>>;
    update(id: number, data: Partial<ObjectifCommercial>): Promise<ObjectifCommercial>;
    toggleStatus(id: number): Promise<ObjectifCommercial>;
    remove(id: number): Promise<ObjectifCommercial>;
}
