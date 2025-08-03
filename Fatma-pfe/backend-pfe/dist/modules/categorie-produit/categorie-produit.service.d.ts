import { Repository } from 'typeorm';
import { CategorieProduit } from './categorie-produit.entity';
import { CreateCategorieDto } from './dto/create-categorie.dto';
export declare class CategorieProduitService {
    private readonly categorieRepository;
    constructor(categorieRepository: Repository<CategorieProduit>);
    create(dto: CreateCategorieDto): Promise<CategorieProduit>;
    getAll(): Promise<CategorieProduit[]>;
    getById(id: number): Promise<CategorieProduit>;
    update(id: number, dto: Partial<CreateCategorieDto>): Promise<CategorieProduit>;
    delete(id: number): Promise<void>;
}
