# Mundial Fantasy - Granular Implementation Plan

This document provides a highly detailed roadmap for the upcoming phases of Mundial Fantasy development.

---

## Phase 3: Player Data & Ingestion (~May 26, 2026)
**Objective**: Transition from placeholders to real-world tournament data.

### 3.1 Data Seeding Infrastructure
- [ ] **Scraper/Seed Script**: Create a Node.js script in `supabase/seed_players.ts` to parse official FIFA squad lists (JSON/CSV).
- [ ] **National Team Matching**: map players to the `national_teams` table using FIFA 3-letter codes.
- [ ] **Price Algorithm**:
  - GK: 4.0m - 6.0m
  - DEF: 4.5m - 7.0m
  - MID: 5.0m - 10.0m
  - FWD: 6.0m - 12.5m
  - Based on club performance and expected minutes.

### 3.2 Semantic Search & Vectorization
- [ ] **Embedding Service**: Use a free embedding model (e.g., `sentence-transformers/all-MiniLM-L6-v2` via Hugging Face) to generate player profile vectors.
- [ ] **pgvector Integration**: Store these in the `embedding` column of the `players` table.
- [ ] **AI Search**: Implement a "Natural Language Player Picker" where users can type "Creative Brazilian winger under 8m".

---

## Phase 4: AI Advisor & Real-time Features
**Objective**: Build the "Smart" layer of the application.

### 4.1 AI Advisor Endpoints (NestJS)
- [ ] **The Scout (`/ai/scout`)**: Suggests "differential" players with low ownership but high potential.
- [ ] **Transfer Doctor (`/ai/transfer-advice`)**: Analyzes the user's current squad for injuries or difficult upcoming fixtures.
- [ ] **Team Optimizer**: Runs a greedy algorithm + AI refinement to pick the best XI for the upcoming gameweek.
- [ ] **Tooling**: Use **Groq API** (Llama 3 70B) for zero-latency AI responses.

### 4.2 Live Match Engine
- [ ] **Live Poller**: A background job that polls **API-FOOTBALL** every 60 seconds during active match windows.
- [ ] **Event Processing**:
  - Convert API events (Goal, Assist, etc.) into `match_events` table entries.
  - Trigger `@mundial/scoring-engine` to calculate `player_match_points`.
- [ ] **Real-time Push**: Use Supabase Realtime to broadcast point updates. Flutter clients listen to the `player_match_points` channel.

---

## Phase 5: Scaling & Production Readiness
**Objective**: Ensure the system handles 10,000+ concurrent users during kickoff.

### 5.1 Load Testing
- [ ] **k6 Simulation**: Write a k6 script to simulate users logging in, drafting a team, and viewing live scores.
- [ ] **Optimization**: Add Redis/In-memory caching in NestJS for the `players` and `matches` lists.

### 5.2 CI/CD & DevOps
- [ ] **GitHub Actions**:
  - **Mobile**: Build and sign Android APK on every tag.
  - **API**: Deploy NestJS to Railway/Vercel on merge to main.
  - **Migrations**: Auto-apply Supabase migrations to production.

### 5.3 Polish & UX
- [ ] **Push Notifications**: Firebase Cloud Messaging (FCM) for lineup deadlines and goal alerts.
- [ ] **Haptic Feedback**: Add subtle haptics in Flutter for drafting/selling players.

---

## Phase 6: Tournament Operation (June 11 – July 19, 2026)
- [ ] **Gameweek Management**: Automatic status switching (Active -> Finished) based on match completions.
- [ ] **Global Leaderboard**: Materialized view in PostgreSQL for high-performance ranking.
- [ ] **Winner Celebration**: End-of-tournament AI-generated highlight reel for each user's team.
