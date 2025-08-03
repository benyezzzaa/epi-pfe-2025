import { CategorieClientService } from './categorie-client.service';
import { CreateCategorieClientDto } from './DTO/create-categorie-client.dto';
import { UpdateCategorieStatusDto } from './DTO/update-categorie-status.dto';
export declare class CategorieClientController {
    private readonly categorieService;
    constructor(categorieService: CategorieClientService);
    createCategorie(dto: CreateCategorieClientDto, req: any): Promise<import("./categorie-client.entity").CategorieClient>;
    getAll(): Promise<import("./categorie-client.entity").CategorieClient[]>;
    updateCategorie(id: number, dto: CreateCategorieClientDto): Promise<import("./categorie-client.entity").CategorieClient>;
    updateStatusPut(id: number, body: UpdateCategorieStatusDto): Promise<import("./categorie-client.entity").CategorieClient>;
}
