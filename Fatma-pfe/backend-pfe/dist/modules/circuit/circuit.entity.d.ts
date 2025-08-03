import { User } from '../users/users.entity';
import { Client } from '../client/client.entity';
export declare class Circuit {
    id: number;
    date: Date;
    commercial: User;
    clients: Client[];
}
