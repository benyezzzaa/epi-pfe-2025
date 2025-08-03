import { User } from '../users/users.entity';
import { Client } from '../client/client.entity';
import { RaisonVisite } from '../raison-visite/raison-visite.entity';
export declare class Visite {
    id: number;
    date: Date;
    client: Client;
    user: User;
    raison: RaisonVisite;
}
