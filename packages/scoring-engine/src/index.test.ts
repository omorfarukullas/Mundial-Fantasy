import { ScoringEngine, PlayerPosition, EventType } from './index';

describe('ScoringEngine', () => {
  test('Defender scoring a goal and getting a clean sheet', () => {
    const points = ScoringEngine.calculatePoints(PlayerPosition.DEF, [
      { type: EventType.MINUTES_PLAYED, value: 90 },
      { type: EventType.GOAL },
      { type: EventType.CLEAN_SHEET },
    ]);
    // 2 (mins) + 6 (goal) + 4 (CS) = 12
    expect(points).toBe(12);
  });

  test('Forward scoring two goals but getting a yellow card', () => {
    const points = ScoringEngine.calculatePoints(PlayerPosition.FWD, [
      { type: EventType.MINUTES_PLAYED, value: 90 },
      { type: EventType.GOAL },
      { type: EventType.GOAL },
      { type: EventType.YELLOW_CARD },
    ]);
    // 2 (mins) + 4 (goal) + 4 (goal) - 1 (yellow) = 9
    expect(points).toBe(9);
  });

  test('Goalkeeper making 6 saves and saving a penalty', () => {
    const points = ScoringEngine.calculatePoints(PlayerPosition.GK, [
      { type: EventType.MINUTES_PLAYED, value: 90 },
      { type: EventType.SAVES, value: 6 },
      { type: EventType.PENALTY_SAVED },
    ]);
    // 2 (mins) + 2 (saves) + 5 (penalty) = 9
    expect(points).toBe(9);
  });
});
