import { RaisonVisiteService } from './raison-visite.service';
export declare class RaisonVisiteController {
    private readonly service;
    constructor(service: RaisonVisiteService);
    findActives(): Promise<import("./raison-visite.entity").RaisonVisite[]>;
    findAll(): Promise<import("./raison-visite.entity").RaisonVisite[]>;
    create(nom: string): Promise<import("./raison-visite.entity").RaisonVisite>;
    update(id: number, body: {
        nom: string;
    }): Promise<import("./raison-visite.entity").RaisonVisite>;
    toggleActive(id: number): Promise<import("./raison-visite.entity").RaisonVisite>;
}
