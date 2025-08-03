import { Repository } from 'typeorm';
import { Client } from './client.entity';
import { CreateClientDto } from './DTO/create-client.dto';
import { User } from '../users/users.entity';
import { Visite } from '../Visite/visite.entity';
import { CategorieClient } from './categorie-client.entity';
export declare class ClientService {
    private clientRepository;
    private visiteRepository;
    private categorieClientRepository;
    constructor(clientRepository: Repository<Client>, visiteRepository: Repository<Visite>, categorieClientRepository: Repository<CategorieClient>);
    private validateSIRET;
    createClient(dto: CreateClientDto, user: User): Promise<Client>;
    getAllClients(): Promise<Client[]>;
    getClientById(id: number): Promise<Client>;
    updateClient(id: number, dto: CreateClientDto, user: User): Promise<Client>;
    deleteClient(id: number, user: User): Promise<{
        message: string;
    }>;
    updateClientStatus(id: number, isActive: boolean, user: User): Promise<{
        message: string;
        client: Client;
    }>;
    getCategoriesDuCommercial(user: User): Promise<CategorieClient[]>;
    getClientsDuCommercial(user: User): Promise<Client[]>;
    getClientsByCommercialId(commercialId: number): Promise<Client[]>;
    getOptimizedPlanning(user: User, currentLat: number, currentLon: number): Promise<{
        id: number;
        nom: string;
        prenom: string;
        adresse: string;
        importance: number;
        distance: number;
        daysSinceLastVisit: number;
        score: number;
    }[]>;
}
