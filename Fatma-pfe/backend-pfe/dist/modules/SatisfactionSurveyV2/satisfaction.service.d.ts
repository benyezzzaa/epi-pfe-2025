import { Repository } from 'typeorm';
import { SatisfactionSurvey } from './satisfaction-survey.entity';
import { SatisfactionResponse } from './satisfaction-response.entity';
import { CreateSurveyDto } from './dto/create-survey.dto';
import { CreateResponseDto } from './dto/create-response.dto';
import { Response } from 'express';
export declare class SatisfactionService {
    private surveyRepo;
    private responseRepo;
    constructor(surveyRepo: Repository<SatisfactionSurvey>, responseRepo: Repository<SatisfactionResponse>);
    createSurvey(dto: CreateSurveyDto): Promise<SatisfactionSurvey>;
    getSurveys(): Promise<SatisfactionSurvey[]>;
    getSurveyById(id: number): Promise<SatisfactionSurvey>;
    generateSurveyQRCode(surveyId: number, baseUrl: string): Promise<any>;
    generateSurveyPdf(surveyId: number, res: Response): Promise<void>;
    createResponse(dto: CreateResponseDto): Promise<SatisfactionResponse>;
}
