---
name: dotnet-quality
description: Use when changing C#, .NET projects, analyzers, tests, or CI configuration. Runs restore, format checks, build verification, unit tests, and dependency audits for .NET changes.
---

# Dotnet Quality Skill

## Purpose
Use this skill whenever working in a .NET repository, especially for C#, analyzers, formatting, tests, and CI validation.

## Goals
- Keep the domain logic separate from the CLI and OS concerns.
- Validate behavior with the smallest relevant .NET command set.
- Prevent regressions before finalizing code changes.

## Required commands
Run the following in order for meaningful validation:

1. `dotnet restore MeetingCost.sln --locked-mode`
2. `dotnet tool restore`
3. `dotnet format MeetingCost.sln --verify-no-changes --verbosity minimal`
4. `dotnet build MeetingCost.sln --configuration Release --no-restore`
5. `dotnet test MeetingCost.sln --configuration Release --no-restore --logger "trx;LogFileName=quality-check.trx"`
6. `dotnet list MeetingCost.sln package --vulnerable --include-transitive`

## Checklist
- Business logic remains in the domain layer.
- CLI code does not contain calculation logic.
- Invalid values are rejected with explicit error messages.
- Tests cover valid input, invalid input, and boundaries.
- Formatting and analyzers are clean.
- No dependency vulnerabilities are introduced.

## Response rule
If a validation step fails, explain the failing command, the cause, and the lowest-effort fix before continuing.
