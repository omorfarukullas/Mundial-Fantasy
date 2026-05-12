import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { DatabaseModule } from './database/database.module';
import { AuthModule } from './modules/auth/auth.module';
import { FantasyModule } from './modules/fantasy/fantasy.module';
import { ScoringModule } from './modules/scoring/scoring.module';
import { LeaguesModule } from './modules/leagues/leagues.module';
import { PlayersModule } from './modules/players/players.module';
import { TransfersModule } from './modules/transfers/transfers.module';
import { LiveModule } from './modules/live/live.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { AiModule } from './modules/ai/ai.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '../../.env',
    }),
    DatabaseModule,
    AuthModule, 
    FantasyModule, 
    ScoringModule, 
    LeaguesModule, 
    PlayersModule, 
    TransfersModule, 
    LiveModule, 
    NotificationsModule, 
    AiModule
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
