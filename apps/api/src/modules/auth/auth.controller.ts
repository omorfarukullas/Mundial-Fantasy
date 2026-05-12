import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { SupabaseAuthGuard } from './supabase-auth.guard';

@Controller('auth')
export class AuthController {
  @UseGuards(SupabaseAuthGuard)
  @Get('profile')
  getProfile(@Request() req) {
    return req.user;
  }
}
