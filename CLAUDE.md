# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build/Test Commands

- `npm ci` - Install dependencies
- `npm run typecheck` - Run TypeScript typecheck
- `npm test` - Run all Vitest tests
- `npx vitest run tests/path/to/file.test.ts` - Run a specific test file
- `npx vitest run tests/path/to/file.test.ts -t "test name"` - Run a specific test

## Code Style Guidelines

- **Module Structure**: Achievements live in `src/achievements/[group]/[level].ts` with mirrored tests under `tests/achievements/**`
- **Naming**: `camelCase` for functions/variables, `PascalCase` for types/interfaces
- **Typing**: Keep `strict` TypeScript compatibility and include explicit exported types
- **Rules**: Every achievement module exports a typed `rule` implementing `AchievementRule`
- **Registry Completeness**: `src/achievements/index.ts` must satisfy `Record<AchievementId, AchievementRule>`
- **Testing**: Keep one mirrored test per achievement module and maintain coverage assertions in `tests/achievements/coverage.test.ts`
