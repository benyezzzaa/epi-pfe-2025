import { Repository } from 'typeorm';
import { Unite } from './unite.entity';
import { CreateUniteDto } from './dto/CreateUniteDto';
export declare class UniteService {
    private uniteRepository;
    constructor(uniteRepository: Repository<Unite>);
    create(dto: CreateUniteDto): Promise<Unite>;
    findAll(options?: {
        search?: string;
        page?: number;
        limit?: number;
    }): Promise<{
        data: Unite[];
        total: number;
        page: number;
        limit: number;
    }>;
    findOne(id: number): Promise<Unite>;
    update(id: number, dto: CreateUniteDto): Promise<Unite>;
    toggleStatus(id: number, isActive: boolean): Promise<Unite>;
    delete(id: number): Promise<void>;
}
