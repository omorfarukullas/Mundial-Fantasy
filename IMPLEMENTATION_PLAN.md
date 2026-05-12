# Mundial Fantasy - Comprehensive Implementation Plan

This document outlines the end-to-end implementation strategy for Mundial Fantasy, focusing on open-source tools and free tiers.

## Phase 1: Foundation (COMPLETED)
- [x] Monorepo structure (pnpm/npm workspace).
- [x] Supabase integration (Auth, PostgreSQL, Migrations).
- [x] Shared TypeScript package for scoring engine.
- [x] Flutter app skeleton with GoRouter and Riverpod.

## Phase 2: Core Fantasy Engine (COMPLETED)
- [x] **Squad Builder**: Pitch view, formation selection (4-4-2, 4-3-3, etc.), and budget tracking.
- [x] **Transfer Logic**: Backend validation for transfer deadlines and gameweek locks.
- [x] **Leagues System**: Creation of private/public leagues, join flow via invite codes, and league membership management.

## Phase 3: Player Data & Ingestion (Upcoming - ~May 26, 2026)
- **Goal**: Populate the system with real-world players once squads are announced.
- **Tasks**:
  1.  **Seed Scripts**: Write TS/Node scripts to fetch or load player data into Supabase.
  2.  **Price Initialization**: Set initial prices for all players based on historical performance/value.
  3.  **Embeddings**: Generate pgvector embeddings for players to enable AI-powered semantic search and recommendations.
  4.  **Flutter Integration**: Replace placeholder players with real data from the `players` table.

## Phase 4: AI Advisor & Real-time Features
- **Goal**: Add a unique value proposition using AI and live data.
- **AI Strategy (Free/Open Source)**:
  - Use **Hugging Face Inference API** (Free Tier) or **Llama 3 (via Groq/Ollama)** for the "AI Scout" and "Transfer Advisor".
  - Implement 4 endpoints: `/ai/scout`, `/ai/transfer-advice`, `/ai/match-preview`, `/ai/team-optimization`.
- **Live Match Engine**:
  - Integrate **API-FOOTBALL** (Free Tier: 100 requests/day) or **Football-Data.org** for live scores.
  - Use Supabase Realtime to push score updates and point changes to Flutter clients instantly.

## Phase 5: Polish, Testing & Deployment
- **Performance**: Use `k6` for load testing match-day spikes.
- **Monitoring**: Set up **Grafana** (Free Tier) connected to Supabase/PostgreSQL metrics.
- **Distribution**: 
  - Android: Generate APK/App Bundle via GitHub Actions.
  - iOS: TestFlight deployment.

## Phase 6: Tournament Operation (June 11 – July 19, 2026)
- Daily automated point calculations after each match.
- Weekly "Dream Team" generation by the AI agent.
- Automated prize/summary distribution for league winners.

---

## Technical Debt & Maintenance
- **Unit Testing**: Maintain 80%+ coverage for `@mundial/scoring-engine`.
- **CI/CD**: Ensure GitHub Actions validate all PRs for both API and Mobile.
- **Security**: Regularly audit RLS (Row Level Security) policies in Supabase.
