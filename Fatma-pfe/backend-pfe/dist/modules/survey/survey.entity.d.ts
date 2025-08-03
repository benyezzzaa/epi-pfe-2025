import { SurveyQuestion } from './survey-question.entity';
export declare class Survey {
    id: number;
    nom: string;
    dateDebut: string;
    dateFin: string;
    questions: SurveyQuestion[];
    createdAt: Date;
}
