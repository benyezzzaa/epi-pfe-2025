import { UniteService } from './unite.service';
import { CreateUniteDto } from './dto/CreateUniteDto';
export declare class UniteController {
    private readonly uniteService;
    constructor(uniteService: UniteService);
    create(dto: CreateUniteDto): Promise<import("./unite.entity").Unite>;
    getAllUnites(): Promise<{
        data: import("./unite.entity").Unite[];
        total: number;
        page: number;
        limit: number;
    }>;
    toggleStatus(id: number, isActive: boolean): Promise<import("./unite.entity").Unite>;
    findAllUnitesFromProduit(search?: string, page?: number, limit?: number): Promise<{
        data: import("./unite.entity").Unite[];
        total: number;
        page: number;
        limit: number;
    }>;
    findOne(id: number): Promise<import("./unite.entity").Unite>;
    update(id: number, dto: CreateUniteDto): Promise<import("./unite.entity").Unite>;
    delete(id: number): Promise<void>;
}
