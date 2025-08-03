import { ReglementService } from './reglement.service';
import { CreateReglementDto } from './dto/create-reglement.dto';
export declare class ReglementController {
    private readonly reglementService;
    constructor(reglementService: ReglementService);
    create(dto: CreateReglementDto): Promise<import("./reglement.entity").Reglement>;
    findAll(): Promise<import("./reglement.entity").Reglement[]>;
}
