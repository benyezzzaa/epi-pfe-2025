import { FactureService } from './facture.service';
import { Facture } from './facture.entity';
export declare class FactureController {
    private readonly factureService;
    constructor(factureService: FactureService);
    getAllFactures(): Promise<Facture[]>;
    getOne(id: number): Promise<Facture>;
    createFacture(factureData: Partial<Facture>): Promise<Facture>;
    deleteFacture(id: number): Promise<void>;
}
