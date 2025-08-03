import { CircuitService } from './circuit.service';
import { CreateCircuitDto } from './DTO/create-circuit.dto';
export declare class CircuitController {
    private readonly service;
    constructor(service: CircuitService);
    create(dto: CreateCircuitDto, req: any): Promise<import("./circuit.entity").Circuit>;
    getTodayCircuit(req: any): Promise<import("./circuit.entity").Circuit | null>;
    getByDate(req: any, date: string): Promise<import("./circuit.entity").Circuit | null>;
}
