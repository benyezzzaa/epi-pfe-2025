import { Survey } from './survey.entity';
import { User } from '../users/users.entity';
import { Client } from '../client/client.entity';
export declare class SurveyAffectation {
    id: number;
    survey: Survey;
    commercial: User;
    client: Client;
}
