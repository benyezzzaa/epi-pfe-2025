import { Repository } from 'typeorm';
import { RaisonVisite } from './raison-visite.entity';
export declare class RaisonVisiteService {
    private readonly raisonRepo;
    constructor(raisonRepo: Repository<RaisonVisite>);
    findAll(): Promise<RaisonVisite[]>;
    create(nom: string): Promise<RaisonVisite>;
    findActive(): Promise<RaisonVisite[]>;
    update(id: number, nom: string): Promise<RaisonVisite>;
    toggleActive(id: number): Promise<RaisonVisite>;
}
