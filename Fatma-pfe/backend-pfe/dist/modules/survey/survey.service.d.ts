import { Repository } from 'typeorm';
import { Survey } from './survey.entity';
import { SurveyQuestion } from './survey-question.entity';
import { SurveyAffectation } from './survey-affectation.entity';
import { CreateSurveyDto } from './dto/create-survey.dto';
import { CreateQuestionDto } from './dto/create-question.dto';
import { CreateAffectationDto } from './dto/create-affectation.dto';
import { User } from '../users/users.entity';
import { Client } from '../client/client.entity';
import { Response } from 'express';
export declare class SurveyService {
    private surveyRepo;
    private questionRepo;
    private affectationRepo;
    private userRepo;
    private clientRepo;
    constructor(surveyRepo: Repository<Survey>, questionRepo: Repository<SurveyQuestion>, affectationRepo: Repository<SurveyAffectation>, userRepo: Repository<User>, clientRepo: Repository<Client>);
    createSurvey(dto: CreateSurveyDto): Promise<Survey>;
    updateSurvey(id: number, dto: Partial<CreateSurveyDto>): Promise<Survey>;
    addQuestion(surveyId: number, dto: CreateQuestionDto): Promise<SurveyQuestion>;
    addAffectation(surveyId: number, dto: CreateAffectationDto): Promise<SurveyAffectation[]>;
    getSurveys(): Promise<Survey[]>;
    getSurveyQuestions(surveyId: number): Promise<SurveyQuestion[]>;
    getSurveyAffectations(surveyId: number): Promise<SurveyAffectation[]>;
    getEnquetesAffecteesCommercial(commercialId: number): Promise<any[]>;
    generateSurveyPdf(surveyId: number, res: Response): Promise<void>;
}
