import { ProduitService } from './produit.service';
import { CreateProduitDto } from './dto/create-produit.dto';
import { File as MulterFile } from 'multer';
import { UpdateProduitDto } from './dto/update-produit.dto';
export declare class ProduitController {
    private readonly produitService;
    constructor(produitService: ProduitService);
    createProduit(dto: CreateProduitDto, files: MulterFile[]): Promise<import("./produit.entity").Produit>;
    getProduits(): Promise<import("./produit.entity").Produit[]>;
    createTestProducts(): Promise<import("./produit.entity").Produit[]>;
    updateProduit(id: string, dto: UpdateProduitDto, files: MulterFile[]): Promise<import("./produit.entity").Produit>;
    updateStatutProduit(id: string, body: {
        isActive: boolean;
    }): Promise<{
        message: string;
    }>;
}
