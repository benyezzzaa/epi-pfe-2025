import { Repository } from 'typeorm';
import { Circuit } from './circuit.entity';
import { CreateCircuitDto } from './DTO/create-circuit.dto';
import { User } from '../users/users.entity';
import { Client } from '../client/client.entity';
export declare class CircuitService {
    private readonly circuitRepo;
    private readonly clientRepo;
    constructor(circuitRepo: Repository<Circuit>, clientRepo: Repository<Client>);
    getTodayCircuit(user: User): Promise<Circuit | null>;
    create(dto: CreateCircuitDto, user: User): Promise<Circuit>;
    findAll(): Promise<Circuit[]>;
    getCircuitByDate(user: User, date: string): Promise<Circuit | null>;
}
