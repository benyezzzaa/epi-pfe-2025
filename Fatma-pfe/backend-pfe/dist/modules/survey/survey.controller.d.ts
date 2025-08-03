import { SurveyService } from './survey.service';
import { CreateSurveyDto } from './dto/create-survey.dto';
import { CreateQuestionDto } from './dto/create-question.dto';
import { CreateAffectationDto } from './dto/create-affectation.dto';
import { Response } from 'express';
export declare class SurveyController {
    private readonly surveyService;
    constructor(surveyService: SurveyService);
    createSurvey(dto: CreateSurveyDto): Promise<import("./survey.entity").Survey>;
    addQuestion(id: string, dto: CreateQuestionDto): Promise<import("./survey-question.entity").SurveyQuestion>;
    addAffectation(id: string, dto: CreateAffectationDto): Promise<import("./survey-affectation.entity").SurveyAffectation[]>;
    updateSurvey(id: string, dto: Partial<CreateSurveyDto>): Promise<import("./survey.entity").Survey>;
    getSurveys(): Promise<import("./survey.entity").Survey[]>;
    getSurveyQuestions(id: string): Promise<import("./survey-question.entity").SurveyQuestion[]>;
    getSurveyAffectations(id: string): Promise<import("./survey-affectation.entity").SurveyAffectation[]>;
    getAffectees(commercialId: number): Promise<any[]>;
    getSurveyPdf(id: number, res: Response): Promise<void>;
}
