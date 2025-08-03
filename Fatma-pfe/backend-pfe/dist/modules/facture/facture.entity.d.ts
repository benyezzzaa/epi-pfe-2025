import { Commande } from '../commande/commande.entity';
import { ReglementFacture } from '../reglement-facture/reglement-facture.entity';
export declare class Facture {
    id: number;
    numero_facture: string;
    date_emission: Date;
    montant_total: number;
    commande: Commande;
    reglementsFactures: ReglementFacture[];
}
