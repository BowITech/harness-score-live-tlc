# Meeting Cost CLI

Estima o custo de mão de obra de uma reunião a partir de participantes, duração
em minutos e custo por hora. É uma CLI Node.js 24 ESM, sem rede e sem estado.

## Estrutura e comandos

- `src/meeting-cost.js` — função pura `calculateMeetingCost`.
- `src/cli.js` — argumentos, `stdout`/`stderr` e código de saída.
- `test/` — testes do domínio com o runner nativo do Node.js.
- `package.json` — `start`, `test`, `lint`, `format`, `typecheck` e `check`.
- `.agents/rules/` — domínio e arquitetura com escopo `src/**`.
- `.agents/skills/add-calculation-case/` — como mudar uma regra de cálculo.
- `.agents/workflows/verificar.md` — verificação com os comandos reais.
- `PROJETO.md` — descrição curta e exemplo. Preserve `README.md` e `LICENSE`.

```powershell
npm start -- 6 45 120
npm run check
```

`check` executa `lint`, `typecheck` e `test`. Biome 2.5.3, TypeScript 5.9.3
(`checkJs`, `noEmit`) e `@types/node` 24.13.3 são só de desenvolvimento.

## Invariantes e limites

- Números finitos; ≥1 participante; duração > 0; custo por hora ≥ 0.
- Fórmula: `participantes * (duraçãoEmMinutos / 60) * custoPorHora`.
- Sem dependências de runtime; nativo ESM (`.js` nas importações). Não avalie
  entrada como código nem grave segredos.
- Não faça commit, push ou tags sem pedido explícito.

Conclusão: domínio puro, CLI só de I/O, sensors via `npm run check`, e o
workflow em `.agents/workflows/verificar.md`.
