import { Repository } from 'typeorm';
import { Reglement } from './reglement.entity';
import { CreateReglementDto } from './dto/create-reglement.dto';
import { TypeReglement } from '../type-reglement/typeReglement.entity';
export declare class ReglementService {
    private readonly reglementRepository;
    private readonly typeReglementRepository;
    constructor(reglementRepository: Repository<Reglement>, typeReglementRepository: Repository<TypeReglement>);
    create(dto: CreateReglementDto): Promise<Reglement>;
    findAll(): Promise<Reglement[]>;
}
