# AI Agent Instructions for Mundial Fantasy (Detailed)

This document provides comprehensive technical instructions and architectural patterns for building and maintaining Mundial Fantasy.

---

## 1. Core Architecture & Monorepo
We use a **pnpm/npm workspace** monorepo:
- `/apps/mobile`: Flutter (UI/State)
- `/apps/api`: NestJS (Business Logic/Database Access)
- `/packages/scoring-engine`: Shared TypeScript logic for all point calculations.
- `/supabase`: Infrastructure as Code (migrations, config).

---

## 2. Frontend: Flutter & Riverpod
### A. State Management Patterns
- **Providers**: Use `AsyncNotifierProvider` for any state that depends on the network.
- **Loading/Error Handling**: Always use `.when()` on `AsyncValue` to show custom loaders or error widgets.
- **Optimization**: Use `ref.select((state) => state.field)` to prevent unnecessary rebuilds of large widgets.
- **Repository Pattern**: Create abstract repository classes in `domain/` and implement them in `data/`. Inject them into providers.

### B. UI & Aesthetics
- **Theme**: Use `ThemeData` with `useMaterial3: true`.
- **Colors**: Vibrant, premium palette (Deep Purples, Electric Blues, and Gold accents). Avoid basic colors.
- **Custom Widgets**:
  - `PitchView`: Handles dynamic formation layouts (4-4-2, etc.).
  - `GlassCard`: A custom widget implementing glassmorphism (BackdropFilter + subtle opacity).

---

## 3. Backend: NestJS & Drizzle
### A. Database Interaction
- **Drizzle Schema**: Located in `apps/api/src/database/schema.ts`.
- **Relational Queries**: Use the `db.query` syntax for clean joins.
- **Transactions**: Complex operations (like processing a transfer or updating points) MUST use `db.transaction`.
- **Migrations**: Always generate migrations in `/supabase/migrations` for every schema change.

### B. Security & Auth
- **Supabase Integration**: NestJS acts as a middleware. It validates the JWT passed in the `Authorization` header via `SupabaseAuthGuard`.
- **RLS (Row Level Security)**: Even though NestJS has a service key, Flutter clients interact with Supabase directly for some reads. Ensure RLS is enabled for tables like `fantasy_teams` and `league_members`.

---

## 4. Shared Scoring Engine
The `@mundial/scoring-engine` is the **Single Source of Truth** for points.
- **Match Events**: GK saves, Goals, Assists, Yellow/Red cards, etc.
- **Position Multipliers**: Points vary by position (e.g., a Goal by a Defender is worth more than a Forward).
- **Unit Testing**: 100% logic coverage is mandatory. Run `npm test` in the package directory before any deployment.

---

## 5. Implementation Workflow (Step-by-Step)
1.  **Backend Migration**: Add columns/tables to `schema.ts` -> Run `supabase db diff` or write migration.
2.  **DTOs & Controllers**: Define the API surface in NestJS.
3.  **Flutter Domain**: Define `Freezed` models. Run `dart run build_runner build`.
4.  **Flutter Data**: Create the Repository/Service to call the API.
5.  **Flutter Presentation**: Build the Screen and connect it via Riverpod.

---

## 6. Open Source & Cost Optimization
- **Database/Auth**: Supabase Free Tier.
- **AI Advisor**: Use **Groq** or **Ollama** for high-speed inference without high costs.
- **Live Match Data**: Use **API-FOOTBALL** (Free Tier: 100/day) or **OpenFootball** datasets.
- **Deployment**: Vercel/Railway for API (Free Tier) and GitHub Actions for mobile builds.

---

## 7. Quality Standards
- **Clean Code**: Follow SOLID principles.
- **Documentation**: All new modules must have a brief README.
- **Logging**: Use the NestJS `Logger` for backend and `debugPrint` (or specialized logger) for Flutter.
