# AI Agent Instructions for Mundial Fantasy

This document provides specific technical context and guidelines for any AI agent tasked with contributing to the Mundial Fantasy project.

## 1. Project Overview
Mundial Fantasy is a professional-grade fantasy football application for international tournaments. It uses a monorepo architecture with a mobile-first approach.

## 2. Tech Stack (Strict Adherence Required)
- **Frontend**: Flutter (3.x+)
  - **State Management**: Riverpod (`flutter_riverpod`)
  - **Navigation**: GoRouter
  - **Networking**: `dio` (for API) and `supabase_flutter` (for real-time/auth)
  - **Code Generation**: `freezed`, `json_serializable`, `build_runner`
- **Backend**: NestJS
  - **Database**: PostgreSQL (via Supabase)
  - **ORM**: Drizzle ORM
  - **Auth**: Supabase Auth (JWT validation in NestJS)
- **Packages**:
  - `@mundial/scoring-engine`: TypeScript package for shared business logic (points calculation).

## 3. Directory Structure
- `/apps/mobile`: Flutter application code.
  - Follow Feature-first architecture: `features/{feature_name}/{domain|presentation|data}`.
- `/apps/api`: NestJS backend.
  - `src/modules`: Domain logic modules.
  - `src/database`: Drizzle schema and connection module.
- `/packages/scoring-engine`: Shared TS logic for points.
- `/supabase`: Local development config, migrations, and seed scripts.

## 4. Key Patterns & Rules
### A. Authentication
- Use `SupabaseAuthGuard` in NestJS for protected routes.
- Access the user ID via `req.user.id` (extracted from the JWT).

### B. State Management (Riverpod)
- Prefer `AsyncNotifier` or `FutureProvider` for network data.
- Use `ref.watch` for reactivity and `ref.read` for one-time actions in buttons.

### C. Database (Drizzle)
- Define schema in `apps/api/src/database/schema.ts`.
- Use Drizzle transactions (`db.transaction`) for multi-step updates (e.g., transfers).
- Always sync migrations in `/supabase/migrations` with schema changes.

### D. Scoring Logic
- All points calculation logic MUST reside in `@mundial/scoring-engine`.
- Never duplicate scoring rules in the Flutter app or NestJS controllers directly.

## 5. Development Workflow
1.  **Schema First**: Update Drizzle schema and generate migrations.
2.  **API Layer**: Implement NestJS service and controller.
3.  **UI Implementation**: Build Flutter widgets and Riverpod providers.
4.  **Codegen**: Run `dart run build_runner build` in `apps/mobile` after model changes.

## 6. Constraints (Open Source & Free Tools)
- Avoid proprietary paid APIs (e.g., OpenAI GPT-4 if cost is an issue; use free tiers or local LLMs).
- Use Supabase's free tier for hosting.
- Use free data sources for match stats (e.g., API-FOOTBALL Free Tier).
