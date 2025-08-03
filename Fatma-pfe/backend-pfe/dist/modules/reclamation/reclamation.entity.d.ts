import { User } from '../users/users.entity';
import { Client } from '../client/client.entity';
export declare class Reclamation {
    id: number;
    sujet: string;
    description: string;
    date: Date;
    status: string;
    user: User;
    client: Client;
}
