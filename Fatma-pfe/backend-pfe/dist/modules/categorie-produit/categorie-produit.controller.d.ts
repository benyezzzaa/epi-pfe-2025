import { CategorieProduitService } from './categorie-produit.service';
import { CreateCategorieDto } from './dto/create-categorie.dto';
export declare class CategorieProduitController {
    private readonly service;
    constructor(service: CategorieProduitService);
    create(dto: CreateCategorieDto): Promise<import("./categorie-produit.entity").CategorieProduit>;
    getAll(): Promise<import("./categorie-produit.entity").CategorieProduit[]>;
    getById(id: number): Promise<import("./categorie-produit.entity").CategorieProduit>;
    update(id: number, dto: Partial<CreateCategorieDto>): Promise<import("./categorie-produit.entity").CategorieProduit>;
    delete(id: number): Promise<void>;
}
