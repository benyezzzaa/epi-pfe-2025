import { Repository } from 'typeorm';
import { ReglementFacture } from './reglement-facture.entity';
export declare class ReglementFactureService {
    private readonly reglementFactureRepository;
    constructor(reglementFactureRepository: Repository<ReglementFacture>);
    findAll(): Promise<ReglementFacture[]>;
}
