---
applyTo: "src/**/*.cs,tests/**/*.cs"
---

# .NET repository instructions

Apply these rules to all C# code under `src` and `tests`.

## Required architecture
- Keep domain logic pure and free from console I/O.
- Keep the CLI entry point focused on argument parsing and terminal output.
- Prefer small, deterministic functions with explicit validation.
- Do not add hidden state or environment coupling to the domain layer.

## Validation and error handling
- Reject invalid data early with actionable messages.
- Treat `NaN`, `Infinity`, and `-Infinity` as invalid numeric input.
- Use `ArgumentOutOfRangeException` for business-rule violations.
- Preserve nullable reference type safety and do not suppress warnings without justification.

## .NET code quality
- Keep naming consistent with C# conventions.
- Use `decimal` for financial values unless a requirement explicitly calls for a different type.
- Avoid unnecessary allocations, catch blocks, and broad exception swallowing.
- Prefer explicit checks over silent coercion.
- Keep tests deterministic and independent.

## Test expectations
- Add or update unit tests for all changed business rules.
- Cover success, boundary values, invalid ranges, and regression scenarios.
- Use xUnit and keep test names descriptive and PascalCase.
- Keep architecture tests for domain and CLI separation when the repo structure matters.

## Execution before completion
- Run the repository quality gate or the smallest relevant subset before concluding work.
- Prefer `pwsh ./build.ps1 format-check`, `pwsh ./build.ps1 test`, and `pwsh ./build.ps1 check` for final validation.
