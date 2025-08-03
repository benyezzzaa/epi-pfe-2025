import { ReglementFactureService } from './reglement-facture.service';
export declare class ReglementFactureController {
    private readonly reglementFactureService;
    constructor(reglementFactureService: ReglementFactureService);
    findAll(): Promise<import("./reglement-facture.entity").ReglementFacture[]>;
}
