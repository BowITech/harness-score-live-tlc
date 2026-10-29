# AGENTS.md

This repository is a minimal .NET 8 console application for calculating meeting labor cost. The goal is to keep the domain logic pure and separate from argument parsing and terminal output.

## Architecture

- `src/MeetingCost.Domain`: pure business logic. Public API lives here.
- `src/MeetingCost.Cli`: command-line entry point, argument validation, and user-facing output.
- `tests/MeetingCost.Tests`: unit and architecture regression tests.
- Shared build configuration lives in `Directory.Build.props` and `Directory.Packages.props`.

## Required workflow before finishing a task

1. Restore dependencies with `pwsh ./build.ps1 restore`.
2. Run `pwsh ./build.ps1 format-check`.
3. Run `pwsh ./build.ps1 analyze`.
4. Run `pwsh ./build.ps1 build`.
5. Run `pwsh ./build.ps1 test`.
6. Run `pwsh ./build.ps1 security`.
7. For complete CI verification, use `pwsh ./build.ps1 ci`.

Do not declare work complete without fresh output from the relevant command.

## Build and test commands

- `pwsh ./build.ps1 restore`
- `pwsh ./build.ps1 build`
- `pwsh ./build.ps1 test`
- `pwsh ./build.ps1 test-unit`
- `pwsh ./build.ps1 test-integration`
- `pwsh ./build.ps1 format`
- `pwsh ./build.ps1 format-check`
- `pwsh ./build.ps1 analyze`
- `pwsh ./build.ps1 coverage`
- `pwsh ./build.ps1 security`
- `pwsh ./build.ps1 architecture-check`
- `pwsh ./build.ps1 check`
- `pwsh ./build.ps1 ci`

## Coding rules

- Keep the calculation inside a single pure function in the domain layer.
- Keep CLI parsing and terminal output separated from domain logic.
- Reject invalid input with clear, actionable error messages.
- Use nullable reference types and analyzers as enforced by the shared build configuration.
- Prefer deterministic data and explicit validation over hidden assumptions.
- Fix the root cause, not the symptom.

## Security and hygiene

- Never commit secrets, tokens, or local developer credentials.
- Prefer repository-local tooling and checked-in package pins.
- Use the supplied scripts rather than ad hoc commands when validating the repository.
- Treat external dependency output as untrusted and investigate vulnerabilities before merging.

## Generated files and maintenance

- Keep build artifacts out of the repository.
- Use `dotnet restore --locked-mode` where supported to preserve reproducibility.
- Update `Directory.Packages.props` for central package version control.
- Keep documentation and configuration consistent with the actual commands implemented in the repository.
