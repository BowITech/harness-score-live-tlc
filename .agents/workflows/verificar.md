---
description: Verifica a Meeting Cost CLI usando somente comandos que existem hoje.
---

# Verificar a Meeting Cost CLI

Execute este workflow quando o usuário pedir para validar, checar ou verificar o projeto. Use só comandos reais.

## Comandos

```powershell
npm start -- <participantes> <duração-em-minutos> <custo-por-hora>
npm test
npm run lint
npm run format
npm run typecheck
npm run check
```

`check` corre `lint`, `typecheck` e `test`. A CI em `.github/workflows/ci.yml` repete `npm ci`, `lint`, `typecheck` e `npm test` no Node.js 24.

Não há hooks, MCP, pre-commit nem workflow do Harness Score.

## Passos

1. `npm run check`
2. Se o cálculo ou a CLI mudaram, `npm start -- 6 45 120` (esperado `540.00` se a fórmula não mudou).

## Relatório

Informe os comandos executados, a quantidade de testes e se lint e typecheck passaram.
