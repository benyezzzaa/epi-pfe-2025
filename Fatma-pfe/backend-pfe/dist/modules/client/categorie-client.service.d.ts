import { Repository } from 'typeorm';
import { CategorieClient } from './categorie-client.entity';
import { CreateCategorieClientDto } from './DTO/create-categorie-client.dto';
export declare class CategorieClientService {
    private readonly categorieRepo;
    constructor(categorieRepo: Repository<CategorieClient>);
    create(dto: CreateCategorieClientDto): Promise<CategorieClient>;
    findAll(): Promise<CategorieClient[]>;
    update(id: number, dto: CreateCategorieClientDto): Promise<CategorieClient>;
    updateStatus(id: number, isActive: boolean): Promise<CategorieClient>;
}
