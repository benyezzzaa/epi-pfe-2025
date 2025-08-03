import { Repository } from 'typeorm';
import { Facture } from './facture.entity';
export declare class FactureService {
    private readonly factureRepository;
    constructor(factureRepository: Repository<Facture>);
    findAll(): Promise<Facture[]>;
    findById(id: number): Promise<Facture | null>;
    create(factureData: Partial<Facture>): Promise<Facture>;
    delete(id: number): Promise<void>;
}
