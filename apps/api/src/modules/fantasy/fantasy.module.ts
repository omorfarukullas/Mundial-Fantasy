import { Module } from '@nestjs/common';
import { FantasyController } from './fantasy.controller';
import { FantasyService } from './fantasy.service';

@Module({
  controllers: [FantasyController],
  providers: [FantasyService]
})
export class FantasyModule {}
