import { Repository } from 'typeorm';
import { Promotion } from './promotion.entity';
import { CreatePromotionDto } from './DTO/CreatePromotionDto.dto';
export declare class PromotionService {
    private readonly promoRepo;
    constructor(promoRepo: Repository<Promotion>);
    create(dto: CreatePromotionDto): Promise<Promotion>;
    findActive(): Promise<Promotion[]>;
    findActives(): Promise<Promotion[]>;
    findAll(): Promise<Promotion[]>;
    update(id: number, dto: CreatePromotionDto): Promise<Promotion>;
    getPromotionsActives(): Promise<Promotion[]>;
    toggleStatus(id: number): Promise<Promotion>;
}
