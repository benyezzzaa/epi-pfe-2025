import { SatisfactionSurvey } from './satisfaction-survey.entity';
export declare class SatisfactionResponse {
    id: number;
    survey: SatisfactionSurvey;
    nomClient: string;
    reponse: string;
    createdAt: Date;
}
