import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AiPredictionController } from './ai-prediction.controller';
import { AiPredictionService } from './ai-prediction.service';
import { Commande } from '../commande/commande.entity';
import { LigneCommande } from '../lignecommande/lignecommande.entity';
import { Produit } from '../produit/produit.entity';
import { CategorieProduit } from '../categorie-produit/categorie-produit.entity';
import { Client } from '../client/client.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Commande,
      LigneCommande,
      Produit,
      CategorieProduit,
      Client,
    ]),
  ],
  controllers: [AiPredictionController],
  providers: [AiPredictionService],
  exports: [AiPredictionService],
})
export class AiPredictionModule {} 