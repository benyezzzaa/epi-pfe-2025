import { ClientService } from './client.service';
import { CreateClientDto } from './DTO/create-client.dto';
import { UpdateClientStatusDto } from './DTO/update-client-status.dto';
export declare class ClientController {
    private readonly clientService;
    constructor(clientService: ClientService);
    createClient(dto: CreateClientDto, req: any): Promise<import("./client.entity").Client>;
    getPlanning(lat: string, lon: string, req: any): Promise<{
        id: number;
        nom: string;
        prenom: string;
        adresse: string;
        importance: number;
        distance: number;
        daysSinceLastVisit: number;
        score: number;
    }[]>;
    getMesCategories(req: any): Promise<import("./categorie-client.entity").CategorieClient[]>;
    getClients(commercialId?: number): Promise<import("./client.entity").Client[]>;
    getMesClients(req: any): Promise<import("./client.entity").Client[]>;
    getClient(id: number): Promise<import("./client.entity").Client>;
    updateClient(id: number, dto: CreateClientDto, req: any): Promise<import("./client.entity").Client>;
    deleteClient(id: number, req: any): Promise<{
        message: string;
    }>;
    updateClientStatus(id: number, body: UpdateClientStatusDto, req: any): Promise<{
        message: string;
        client: import("./client.entity").Client;
    }>;
    optionsClientStatus(): Promise<{
        status: string;
        methods: string;
        allowedHeaders: string;
    }>;
}
