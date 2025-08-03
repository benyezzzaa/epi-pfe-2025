import { SatisfactionService } from './satisfaction.service';
import { CreateSurveyDto } from './dto/create-survey.dto';
import { CreateResponseDto } from './dto/create-response.dto';
import { Response } from 'express';
export declare class SatisfactionController {
    private readonly satisfactionService;
    constructor(satisfactionService: SatisfactionService);
    createSurvey(dto: CreateSurveyDto): Promise<import("./satisfaction-survey.entity").SatisfactionSurvey>;
    getSurveys(): Promise<import("./satisfaction-survey.entity").SatisfactionSurvey[]>;
    getSurvey(id: number): Promise<import("./satisfaction-survey.entity").SatisfactionSurvey>;
    getSurveyQRCode(id: number, baseUrl: string): Promise<{
        qrCode: any;
    }>;
    getSurveyPdf(id: number, res: Response): Promise<void>;
    createResponse(dto: CreateResponseDto): Promise<import("./satisfaction-response.entity").SatisfactionResponse>;
}
