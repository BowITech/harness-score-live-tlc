# Engineering Harness Overview

This repository uses a lightweight engineering harness centered on the .NET SDK and repository-local scripts. The goal is to provide deterministic feedback for both developers and coding agents without introducing unnecessary infrastructure.

## Components

- `global.json` pins the .NET SDK version.
- `Directory.Build.props` enforces nullable, analyzer, and warning-as-error defaults.
- `Directory.Packages.props` centralizes package versions.
- `.editorconfig` standardizes formatting and coding style.
- `build.ps1` provides the authoritative local command interface.
- `dotnet` and `dotnet-format` are used for restore, build, test, formatting, and security checks.
- GitHub Actions in `.github/workflows/ci.yml` mirrors the same quality gate in CI.

## Feedback mechanisms

1. Build and compiler diagnostics: run via `dotnet build` and `pwsh ./build.ps1 build`.
2. Static analysis: enforced by .NET analyzers and `build.ps1 analyze`.
3. Formatting: `dotnet format` and `format-check`.
4. Unit and architecture tests: `dotnet test` and `pwsh ./build.ps1 test`.
5. Coverage collection: `pwsh ./build.ps1 coverage`.
6. Dependency security audit: `dotnet list package --vulnerable` through `pwsh ./build.ps1 security`.
7. CI status: GitHub Actions runs the same gate on pull requests and pushes to `main`.

## Failure handling

The harness is intentionally strict: warnings are treated as errors and formatting drift is rejected. The full quality gate is `pwsh ./build.ps1 check` or `pwsh ./build.ps1 ci`.

## Local development

Use the repository script rather than ad hoc commands so that every environment follows the same path.
