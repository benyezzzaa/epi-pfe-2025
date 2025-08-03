import { Repository } from 'typeorm';
import { TypeReglement } from './typeReglement.entity';
export declare class TypeReglementService {
    private typeReglementRepository;
    constructor(typeReglementRepository: Repository<TypeReglement>);
    createTypeReglement(nom: string): Promise<TypeReglement>;
    getAllTypes(): Promise<TypeReglement[]>;
}
