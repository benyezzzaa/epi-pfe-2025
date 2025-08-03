import { TypeReglement } from '../type-reglement/typeReglement.entity';
import { ReglementFacture } from '../reglement-facture/reglement-facture.entity';
export declare class Reglement {
    id: number;
    mode_paiement: string;
    montant: number;
    montantPaye: number;
    datePaiement: Date;
    statut: string;
    typeReglement: TypeReglement;
    reglementsFactures: ReglementFacture[];
}
