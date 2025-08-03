import { Reglement } from '../reglement/reglement.entity';
import { Facture } from '../facture/facture.entity';
export declare class ReglementFacture {
    id: number;
    reglement: Reglement;
    facture: Facture;
}
