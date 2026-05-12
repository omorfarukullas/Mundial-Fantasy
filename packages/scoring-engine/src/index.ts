export enum EventType {
  GOAL = 'GOAL',
  ASSIST = 'ASSIST',
  CLEAN_SHEET = 'CLEAN_SHEET',
  YELLOW_CARD = 'YELLOW_CARD',
  RED_CARD = 'RED_CARD',
  PENALTY_SAVED = 'PENALTY_SAVED',
  PENALTY_MISSED = 'PENALTY_MISSED',
  OWN_GOAL = 'OWN_GOAL',
  SAVES = 'SAVES',
  MINUTES_PLAYED = 'MINUTES_PLAYED',
}

export enum PlayerPosition {
  GK = 'GK',
  DEF = 'DEF',
  MID = 'MID',
  FWD = 'FWD',
}

export interface MatchEvent {
  type: EventType;
  value?: number;
}

export class ScoringEngine {
  static calculatePoints(position: PlayerPosition, events: MatchEvent[]): number {
    let totalPoints = 0;

    for (const event of events) {
      switch (event.type) {
        case EventType.MINUTES_PLAYED:
          if ((event.value ?? 0) >= 60) totalPoints += 2;
          else if ((event.value ?? 0) > 0) totalPoints += 1;
          break;

        case EventType.GOAL:
          if (position === PlayerPosition.GK || position === PlayerPosition.DEF) totalPoints += 6;
          else if (position === PlayerPosition.MID) totalPoints += 5;
          else totalPoints += 4;
          break;

        case EventType.ASSIST:
          totalPoints += 3;
          break;

        case EventType.CLEAN_SHEET:
          if (position === PlayerPosition.GK || position === PlayerPosition.DEF) totalPoints += 4;
          else if (position === PlayerPosition.MID) totalPoints += 1;
          break;

        case EventType.SAVES:
          if (position === PlayerPosition.GK) {
            totalPoints += Math.floor((event.value ?? 0) / 3);
          }
          break;

        case EventType.PENALTY_SAVED:
          totalPoints += 5;
          break;

        case EventType.YELLOW_CARD:
          totalPoints -= 1;
          break;

        case EventType.RED_CARD:
          totalPoints -= 3;
          break;

        case EventType.OWN_GOAL:
          totalPoints -= 2;
          break;

        case EventType.PENALTY_MISSED:
          totalPoints -= 2;
          break;
      }
    }

    return totalPoints;
  }
}
