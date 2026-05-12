-- Users
CREATE TABLE users (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email       TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL,
  avatar_url  TEXT,
  provider    TEXT NOT NULL DEFAULT 'email', -- 'email' | 'google'
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- National Teams
CREATE TABLE national_teams (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT NOT NULL,
  code        CHAR(3) NOT NULL UNIQUE, -- 'BRA', 'FRA', 'ARG'
  group_name  CHAR(1),                 -- 'A'–'L'
  flag_url    TEXT,
  confederation TEXT
);

-- Players (seeded after squad announcements ~May 25)
CREATE TABLE players (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  team_id       UUID REFERENCES national_teams(id),
  name          TEXT NOT NULL,
  short_name    TEXT,
  position      TEXT NOT NULL CHECK (position IN ('GK','DEF','MID','FWD')),
  jersey_number INT,
  price         DECIMAL(5,1) NOT NULL, -- e.g. 10.5 (millions)
  photo_url     TEXT,
  is_available  BOOLEAN DEFAULT TRUE,
  -- pgvector will be enabled in a separate migration or if extension is active
  -- embedding     vector(1536),          
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- Matches
CREATE TABLE matches (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  home_team_id UUID REFERENCES national_teams(id),
  away_team_id UUID REFERENCES national_teams(id),
  stage        TEXT NOT NULL,  -- 'group' | 'r32' | 'r16' | 'qf' | 'sf' | 'final'
  gameweek     INT NOT NULL,   -- 1–20 (logical grouping for fantasy)
  venue        TEXT,
  kickoff_at   TIMESTAMPTZ NOT NULL,
  status       TEXT DEFAULT 'scheduled', -- 'scheduled'|'live'|'finished'
  home_score   INT DEFAULT 0,
  away_score   INT DEFAULT 0
);

-- Match Events (goals, assists, cards)
CREATE TABLE match_events (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id   UUID REFERENCES matches(id),
  player_id  UUID REFERENCES players(id),
  event_type TEXT NOT NULL, -- 'goal'|'assist'|'yellow'|'red'|'save'|'own_goal'|'penalty_miss'
  minute     INT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Fantasy Teams
CREATE TABLE fantasy_teams (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID REFERENCES users(id),
  name       TEXT NOT NULL,
  total_pts  INT DEFAULT 0,
  gw_pts     INT DEFAULT 0,   -- current gameweek points
  budget_rem DECIMAL(5,1) DEFAULT 100.0,
  wildcard_used BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Fantasy Team Players (15 slots)
CREATE TABLE fantasy_team_players (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  fantasy_team_id  UUID REFERENCES fantasy_teams(id),
  player_id        UUID REFERENCES players(id),
  slot_position    TEXT NOT NULL, -- 'GK'|'DEF1'–'DEF4'|'MID1'–'MID4'|'FWD1'–'FWD3'|'BENCH1'–'BENCH3'
  is_captain       BOOLEAN DEFAULT FALSE,
  is_vice_captain  BOOLEAN DEFAULT FALSE,
  is_on_bench      BOOLEAN DEFAULT FALSE,
  UNIQUE(fantasy_team_id, player_id)
);

-- Player Points Per Match
CREATE TABLE player_match_points (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id  UUID REFERENCES players(id),
  match_id   UUID REFERENCES matches(id),
  points     INT DEFAULT 0,
  breakdown  JSONB,  -- { "goals": 12, "assists": 3, "yellow": -1, ... }
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(player_id, match_id)
);

-- Transfers
CREATE TABLE transfers (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  fantasy_team_id UUID REFERENCES fantasy_teams(id),
  player_out_id   UUID REFERENCES players(id),
  player_in_id    UUID REFERENCES players(id),
  gameweek        INT NOT NULL,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Leagues (mini-leagues)
CREATE TABLE leagues (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name         TEXT NOT NULL,
  invite_code  TEXT UNIQUE NOT NULL DEFAULT substr(md5(random()::text), 1, 8),
  creator_id   UUID REFERENCES users(id),
  is_public    BOOLEAN DEFAULT FALSE,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- League Members
CREATE TABLE league_members (
  league_id       UUID REFERENCES leagues(id),
  fantasy_team_id UUID REFERENCES fantasy_teams(id),
  joined_at       TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (league_id, fantasy_team_id)
);

-- Users can only read/update their own profile
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "own profile" ON users
  USING (auth.uid() = id);

-- Fantasy teams — owner only
ALTER TABLE fantasy_teams ENABLE ROW LEVEL SECURITY;
CREATE POLICY "own team" ON fantasy_teams
  USING (auth.uid() = user_id);

-- Fantasy team players — readable by league members
ALTER TABLE fantasy_team_players ENABLE ROW LEVEL SECURITY;
CREATE POLICY "team players visible in league" ON fantasy_team_players
  USING (
    fantasy_team_id IN (
      SELECT fantasy_team_id FROM league_members
      WHERE league_id IN (
        SELECT league_id FROM league_members
        WHERE fantasy_team_id IN (
          SELECT id FROM fantasy_teams WHERE user_id = auth.uid()
        )
      )
    )
  );

-- Transfers — owner only
ALTER TABLE transfers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "own transfers" ON transfers
  USING (
    fantasy_team_id IN (
      SELECT id FROM fantasy_teams WHERE user_id = auth.uid()
    )
  );
