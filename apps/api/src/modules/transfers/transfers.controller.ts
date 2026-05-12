import { Controller, Post, Body, UseGuards, Request } from '@nestjs/common';
import { TransfersService } from './transfers.service';
import { SupabaseAuthGuard } from '../auth/supabase-auth.guard';

@Controller('transfers')
export class TransfersController {
  constructor(private readonly transfersService: TransfersService) {}

  @UseGuards(SupabaseAuthGuard)
  @Post()
  async executeTransfer(
    @Request() req,
    @Body() body: { fantasyTeamId: string; playerOutId: string; playerInId: string }
  ) {
    return this.transfersService.performTransfer(
      req.user.id,
      body.fantasyTeamId,
      body.playerOutId,
      body.playerInId
    );
  }
}
