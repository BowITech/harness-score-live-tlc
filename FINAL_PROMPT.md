Create a complete quality engineering setup for this repository while keeping the product functional and the architecture correct, in a single prompt.

Project context:
- Minimal .NET 8 repository for a meeting cost calculation CLI.
- Product behavior: take participants, duration in minutes, and hourly rate; calculate the total labor cost; reject invalid values; and show clear success and error output.
- The calculation logic must remain in a pure domain function, exported.
- Argument parsing and terminal output must remain in a separate entry point.
- README.md and LICENSE must remain unchanged.

Main objective:
- Raise this repository to a strong and automated harness maturity level, suitable for both human developers and coding agents.
- The result should be a real, useful, reproducible, and appropriately lean engineering harness for a simple .NET application.

Required tasks:
1. Assess the current repository state before changing any files.
2. Create or adjust the appropriate .NET solution with clear projects for domain, CLI, and tests.
3. Use an explicit compatible .NET SDK with `global.json` and a deliberate roll-forward policy.
4. Configure `Directory.Build.props` and `Directory.Packages.props` to ensure:
   - nullable reference types
   - implicit usings
   - modern language version
   - warnings-as-errors when appropriate
   - enabled analyzers
   - determinism and reproducibility
5. Configure `.editorconfig` with good formatting and C# style conventions.
6. Create an authoritative local validation script, such as `build.ps1`, with commands equivalent to:
   - restore
   - build
   - test
   - test-unit
   - test-integration
   - format
   - format-check
   - analyze
   - coverage
   - security
   - architecture-check
   - check
   - ci
7. Add real domain and regression tests:
   - valid calculation
   - invalid participants
   - invalid duration
   - invalid hourly rate
   - edge cases and regression scenarios
8. Keep the project structure separated between domain and CLI, without mixing calculation logic with input/output handling.
9. Create `AGENTS.md` as the authoritative guide for coding agents.
10. Create CI workflow in `.github/workflows/ci.yml` to validate:
    - restore
    - build
    - format
    - tests
    - static analysis
    - security
    - quality gate
11. Configure support tooling for better engineering:
    - `.config/dotnet-tools.json`
    - `.githooks/pre-commit`
    - versioned hooks to prevent dangerous operations and run quick validation after edits
12. Configure context-specific instructions for C# in `.github/instructions/dotnet.instructions.md` with recognizable frontmatter.
13. Configure reusable skills and commands in `.claude/skills/dotnet-quality/SKILL.md` and `.claude/commands/check.md`.
14. Add a review subagent in `.claude/agents/code-reviewer.md`.
15. Configure `.claude/settings.json` with hooks supported by Claude Code and versioned scripts in `.claude/hooks/`.
16. Add a lockfile and appropriate dependency manifest for reproducibility, without creating unnecessary redundancy.
17. Ensure final validation uses real repository commands rather than fake checks.
18. Make sure everything works in the real Windows and .NET environment available.

Critical quality rules:
- Do not invent empty dependencies or useless files just to inflate the score.
- Do not make the solution depend on agents in order to function.
- The goal is a real, useful, and sustainable engineering harness.
- Business logic must remain simple, clean, and testable.
- Do not change README.md or LICENSE.
- Do not commit.

Mandatory final validation:
- Run the relevant repository commands and confirm the result.
- Run at least:
  - `dotnet test MeetingCost.sln --nologo`
  - `pwsh ./build.ps1 check`
  - `npx --yes harness-score .`
- Only report completion after those commands have been executed and their results observed.

Expected outcome:
- Functional, validated .NET application.
- Robust and reproducible engineering harness.
- Working CI and automated feedback.
- Clear documentation and agent guidance.
- Architecture ready for AI-assisted development without bloating the repository with unnecessary files.

At the end, report:
- what was created;
- the commands executed;
- the results observed;
- and the maturity level reached, if applicable.
