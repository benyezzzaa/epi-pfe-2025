import { LigneCommandeService } from './lignecommande.service';
import { LigneCommandeDto } from './dto/create-ligneCommande.dto';
import { updateLigneCommandeDto } from './dto/update-ligneCommande.dto';
export declare class LigneCommandeController {
    private readonly ligneCommandeService;
    constructor(ligneCommandeService: LigneCommandeService);
    getAllLignesCommande(): Promise<LigneCommandeDto[]>;
    updateLigneCommande(id: number, updateDto: updateLigneCommandeDto): Promise<import("./lignecommande.entity").LigneCommande>;
}
