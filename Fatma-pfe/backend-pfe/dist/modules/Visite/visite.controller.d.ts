import { VisiteService } from './visite.service';
import { CreateVisiteDto } from './dto/create-visite.dto';
import { Visite } from './visite.entity';
export declare class VisiteController {
    private readonly visiteService;
    constructor(visiteService: VisiteService);
    createVisite(dto: CreateVisiteDto, req: any): Promise<Visite>;
    getMyVisites(req: any): Promise<Visite[]>;
    getAllVisites(): Promise<Visite[]>;
    getVisitesByCommercial(id: number, req: any): Promise<Visite[]>;
    deleteVisite(id: number, req: any): Promise<void>;
    findAll(): Promise<Visite[]>;
}
