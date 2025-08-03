import { CreatePromotionDto } from './DTO/CreatePromotionDto.dto';
import { PromotionService } from './Promotion.Service';
export declare class PromotionController {
    private readonly promoService;
    constructor(promoService: PromotionService);
    create(dto: CreatePromotionDto): Promise<import("./promotion.entity").Promotion>;
    findActivePromotionsForCommercial(): Promise<import("./promotion.entity").Promotion[]>;
    findAll(req: any): Promise<import("./promotion.entity").Promotion[]>;
    getActives(): Promise<import("./promotion.entity").Promotion[]>;
    updateFromBody(dto: CreatePromotionDto & {
        id: number;
    }): Promise<import("./promotion.entity").Promotion>;
    toggleStatus(id: number): Promise<import("./promotion.entity").Promotion>;
}
