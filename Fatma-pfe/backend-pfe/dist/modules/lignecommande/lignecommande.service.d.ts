import { Repository } from 'typeorm';
import { LigneCommande } from './lignecommande.entity';
import { updateLigneCommandeDto } from './dto/update-ligneCommande.dto';
import { CommandeService } from '../commande/commande.service';
export declare class LigneCommandeService {
    private ligneCommandeRepository;
    private commandeService;
    constructor(ligneCommandeRepository: Repository<LigneCommande>, commandeService: CommandeService);
    getAllLignesCommande(): Promise<LigneCommande[]>;
    updateLigneCommande(id: number, updateDto: updateLigneCommandeDto): Promise<LigneCommande>;
}
