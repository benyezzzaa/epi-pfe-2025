import { Repository } from 'typeorm';
import { Produit } from './produit.entity';
import { CreateProduitDto } from './dto/create-produit.dto';
import { CategorieProduit } from '../categorie-produit/categorie-produit.entity';
import { Unite } from '../unite/unite.entity';
import { UpdateProduitDto } from './dto/update-produit.dto';
export declare class ProduitService {
    private produitRepository;
    private categorieProduitRepository;
    private uniteRepository;
    constructor(produitRepository: Repository<Produit>, categorieProduitRepository: Repository<CategorieProduit>, uniteRepository: Repository<Unite>);
    createProduit(dto: CreateProduitDto, imageFilenames?: string[]): Promise<Produit>;
    getAllProduits(): Promise<Produit[]>;
    updateProduit(id: number, dto: UpdateProduitDto, imageFilenames?: string[]): Promise<Produit>;
    updateStatut(id: number, isActive: boolean): Promise<{
        message: string;
    }>;
    createTestProducts(): Promise<Produit[]>;
}
