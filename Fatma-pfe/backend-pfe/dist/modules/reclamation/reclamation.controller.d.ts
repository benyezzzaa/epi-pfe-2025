import { ReclamationService } from './reclamation.service';
import { CreateReclamationDto } from './DTO/create-reclamation.dto';
export declare class ReclamationController {
    private service;
    constructor(service: ReclamationService);
    findOpen(): Promise<import("./reclamation.entity").Reclamation[]>;
    create(dto: CreateReclamationDto, req: any): Promise<import("./reclamation.entity").Reclamation>;
    findAll(): Promise<import("./reclamation.entity").Reclamation[]>;
    findByUser(req: any): Promise<import("./reclamation.entity").Reclamation[]>;
    updateStatus(id: number, status: string): Promise<import("./reclamation.entity").Reclamation>;
}
