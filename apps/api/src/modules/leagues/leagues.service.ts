import { Injectable, Inject, BadRequestException, NotFoundException } from '@nestjs/common';
import { DB_CONNECTION } from '../../database/database.module';
import * as schema from '../../database/schema';
import { eq, and } from 'drizzle-orm';

@Injectable()
export class LeaguesService {
  constructor(
    @Inject(DB_CONNECTION)
    private db: any,
  ) {}

  async createLeague(creatorId: string, name: string, isPublic: boolean = false) {
    const inviteCode = Math.random().toString(36).substring(2, 10).toUpperCase();

    return await this.db.transaction(async (tx) => {
      const [newLeague] = await tx.insert(schema.leagues).values({
        name,
        creatorId,
        inviteCode,
        isPublic,
      }).returning();

      const team = await tx.query.fantasyTeams.findFirst({
        where: eq(schema.fantasyTeams.userId, creatorId),
      });

      if (team) {
        await tx.insert(schema.leagueMembers).values({
          leagueId: newLeague.id,
          fantasyTeamId: team.id,
        });
      }

      return newLeague;
    });
  }

  async joinLeague(userId: string, inviteCode: string) {
    const league = await this.db.query.leagues.findFirst({
      where: eq(schema.leagues.inviteCode, inviteCode.toUpperCase()),
    });

    if (!league) {
      throw new NotFoundException('League not found with this invite code');
    }

    const team = await this.db.query.fantasyTeams.findFirst({
      where: eq(schema.fantasyTeams.userId, userId),
    });

    if (!team) {
      throw new BadRequestException('You must create a fantasy team before joining a league');
    }

    const existingMember = await this.db.query.leagueMembers.findFirst({
      where: and(
        eq(schema.leagueMembers.leagueId, league.id),
        eq(schema.leagueMembers.fantasyTeamId, team.id)
      ),
    });

    if (existingMember) {
      throw new BadRequestException('Already a member of this league');
    }

    await this.db.insert(schema.leagueMembers).values({
      leagueId: league.id,
      fantasyTeamId: team.id,
    });

    return league;
  }

  async getUserLeagues(userId: string) {
    const team = await this.db.query.fantasyTeams.findFirst({
      where: eq(schema.fantasyTeams.userId, userId),
    });

    if (!team) return [];

    return await this.db.query.leagueMembers.findMany({
      where: eq(schema.leagueMembers.fantasyTeamId, team.id),
      with: {
        league: true,
      },
    });
  }
}
