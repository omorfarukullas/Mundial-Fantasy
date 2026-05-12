import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { LeaguesService } from './leagues.service';
import { SupabaseAuthGuard } from '../auth/supabase-auth.guard';

@Controller('leagues')
export class LeaguesController {
  constructor(private readonly leaguesService: LeaguesService) {}

  @UseGuards(SupabaseAuthGuard)
  @Get('my')
  async getMyLeagues(@Request() req) {
    return this.leaguesService.getUserLeagues(req.user.id);
  }

  @UseGuards(SupabaseAuthGuard)
  @Post('create')
  async createLeague(@Request() req, @Body() body: { name: string; isPublic?: boolean }) {
    return this.leaguesService.createLeague(req.user.id, body.name, body.isPublic);
  }

  @UseGuards(SupabaseAuthGuard)
  @Post('join')
  async joinLeague(@Request() req, @Body() body: { inviteCode: string }) {
    return this.leaguesService.joinLeague(req.user.id, body.inviteCode);
  }
}
