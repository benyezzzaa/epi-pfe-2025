import { TypeReglementService } from './type-reglement.service';
export declare class TypeReglementController {
    private readonly typeReglementService;
    constructor(typeReglementService: TypeReglementService);
    createTypeReglement(body: {
        nom: string;
    }): Promise<import("./typeReglement.entity").TypeReglement>;
    getAllTypes(): Promise<import("./typeReglement.entity").TypeReglement[]>;
}
