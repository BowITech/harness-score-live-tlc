---
description: Run the repository's .NET quality gate.
---

# Check .NET quality

Execute the repository validation sequence before finalizing any C# change.

```powershell
dotnet restore MeetingCost.sln --locked-mode
dotnet tool restore
dotnet format MeetingCost.sln --verify-no-changes --verbosity minimal
dotnet build MeetingCost.sln --configuration Release --no-restore
dotnet test MeetingCost.sln --configuration Release --no-restore --logger "trx;LogFileName=agent-check.trx"
dotnet list MeetingCost.sln package --vulnerable --include-transitive
```

If any step fails, stop and fix the root cause before moving on.
