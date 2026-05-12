import { Injectable, Inject, BadRequestException, ForbiddenException } from '@nestjs/common';
import { DB_CONNECTION } from '../../database/database.module';
import * as schema from '../../database/schema';
import { eq, and } from 'drizzle-orm';

@Injectable()
export class TransfersService {
  constructor(
    @Inject(DB_CONNECTION)
    private db: any,
  ) {}

  async performTransfer(userId: string, fantasyTeamId: string, playerOutId: string, playerInId: string) {
    const activeGw = await this.db.query.gameweeks.findFirst({
      where: eq(schema.gameweeks.isActive, true),
    });

    if (!activeGw) {
      throw new BadRequestException('No active gameweek found');
    }

    if (new Date() > new Date(activeGw.deadlineAt)) {
      throw new ForbiddenException(`Gameweek ${activeGw.id} is locked. Deadline was ${activeGw.deadlineAt}`);
    }

    const team = await this.db.query.fantasyTeams.findFirst({
      where: and(
        eq(schema.fantasyTeams.id, fantasyTeamId),
        eq(schema.fantasyTeams.userId, userId)
      ),
    });

    if (!team) {
      throw new ForbiddenException('You do not own this fantasy team');
    }

    return await this.db.transaction(async (tx) => {
      await tx.delete(schema.fantasyTeamPlayers)
        .where(and(
          eq(schema.fantasyTeamPlayers.fantasyTeamId, fantasyTeamId),
          eq(schema.fantasyTeamPlayers.playerId, playerOutId)
        ));

      await tx.insert(schema.fantasyTeamPlayers).values({
        fantasyTeamId,
        playerId: playerInId,
        slotPosition: 'TEMP', 
      });

      await tx.insert(schema.transfers).values({
        fantasyTeamId,
        playerOutId,
        playerInId,
        gameweek: activeGw.id,
      });

      return { success: true, gameweek: activeGw.id };
    });
  }
}
