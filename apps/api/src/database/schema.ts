import { pgTable, uuid, text, timestamp, boolean, decimal, integer, jsonb, vector } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: uuid('id').defaultRandom().primaryKey(),
  email: text('email').unique().notNull(),
  displayName: text('display_name').notNull(),
  avatarUrl: text('avatar_url'),
  provider: text('provider').default('email').notNull(),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).defaultNow(),
});

export const nationalTeams = pgTable('national_teams', {
  id: uuid('id').defaultRandom().primaryKey(),
  name: text('name').notNull(),
  code: text('code').notNull().unique(), // Changed char(3) to text for simplicity in TS
  groupName: text('group_name'),         // Changed char(1) to text
  flagUrl: text('flag_url'),
  confederation: text('confederation'),
});

export const players = pgTable('players', {
  id: uuid('id').defaultRandom().primaryKey(),
  teamId: uuid('team_id').references(() => nationalTeams.id),
  name: text('name').notNull(),
  shortName: text('short_name'),
  position: text('position').notNull(),
  jerseyNumber: integer('jersey_number'),
  price: decimal('price', { precision: 5, scale: 1 }).notNull(),
  photoUrl: text('photo_url'),
  isAvailable: boolean('is_available').default(true),
  embedding: vector('embedding', { dimensions: 1536 }),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow(),
});

export const matches = pgTable('matches', {
  id: uuid('id').defaultRandom().primaryKey(),
  homeTeamId: uuid('home_team_id').references(() => nationalTeams.id),
  awayTeamId: uuid('away_team_id').references(() => nationalTeams.id),
  stage: text('stage').notNull(),
  gameweek: integer('gameweek').notNull(),
  venue: text('venue'),
  kickoffAt: timestamp('kickoff_at', { withTimezone: true }).notNull(),
  status: text('status').default('scheduled'),
  homeScore: integer('home_score').default(0),
  awayScore: integer('away_score').default(0),
});

export const matchEvents = pgTable('match_events', {
  id: uuid('id').defaultRandom().primaryKey(),
  matchId: uuid('match_id').references(() => matches.id),
  playerId: uuid('player_id').references(() => players.id),
  eventType: text('event_type').notNull(),
  minute: integer('minute'),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow(),
});

export const fantasyTeams = pgTable('fantasy_teams', {
  id: uuid('id').defaultRandom().primaryKey(),
  userId: uuid('user_id').references(() => users.id),
  name: text('name').notNull(),
  totalPts: integer('total_pts').default(0),
  gwPts: integer('gw_pts').default(0),
  budgetRem: decimal('budget_rem', { precision: 5, scale: 1 }).default('100.0'),
  wildcardUsed: boolean('wildcard_used').default(false),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow(),
});

export const fantasyTeamPlayers = pgTable('fantasy_team_players', {
  id: uuid('id').defaultRandom().primaryKey(),
  fantasyTeamId: uuid('fantasy_team_id').references(() => fantasyTeams.id),
  playerId: uuid('player_id').references(() => players.id),
  slotPosition: text('slot_position').notNull(),
  isCaptain: boolean('is_captain').default(false),
  isViceCaptain: boolean('is_vice_captain').default(false),
  isOnBench: boolean('is_on_bench').default(false),
});

export const playerMatchPoints = pgTable('player_match_points', {
  id: uuid('id').defaultRandom().primaryKey(),
  playerId: uuid('player_id').references(() => players.id),
  matchId: uuid('match_id').references(() => matches.id),
  points: integer('points').default(0),
  breakdown: jsonb('breakdown'),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow(),
});

export const transfers = pgTable('transfers', {
  id: uuid('id').defaultRandom().primaryKey(),
  fantasyTeamId: uuid('fantasy_team_id').references(() => fantasyTeams.id),
  playerOutId: uuid('player_out_id').references(() => players.id),
  playerInId: uuid('player_in_id').references(() => players.id),
  gameweek: integer('gameweek').notNull(),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow(),
});

export const leagues = pgTable('leagues', {
  id: uuid('id').defaultRandom().primaryKey(),
  name: text('name').notNull(),
  inviteCode: text('invite_code').unique().notNull(), 
  creatorId: uuid('creator_id').references(() => users.id),
  isPublic: boolean('is_public').default(false),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow(),
});

export const leagueMembers = pgTable('league_members', {
  leagueId: uuid('league_id').references(() => leagues.id),
  fantasyTeamId: uuid('fantasy_team_id').references(() => fantasyTeams.id),
  joinedAt: timestamp('joined_at', { withTimezone: true }).defaultNow(),
});

export const gameweeks = pgTable('gameweeks', {
  id: integer('id').primaryKey(),
  deadlineAt: timestamp('deadline_at', { withTimezone: true }).notNull(),
  isActive: boolean('is_active').default(false),
  isFinished: boolean('is_finished').default(false),
});
