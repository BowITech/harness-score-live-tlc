# Meeting Cost CLI

Estima o custo de mão de obra de uma reunião a partir de participantes, duração
em minutos e custo por hora. É uma CLI Node.js 24 ESM, sem rede e sem estado.

## Estrutura e comandos

- `src/meeting-cost.js` — função pura `calculateMeetingCost`.
- `src/cli.js` — argumentos, `stdout`/`stderr` e código de saída.
- `package.json` — único script: `npm start` → `node src/cli.js`.
- `.agents/rules/` — domínio e arquitetura com escopo `src/**`.
- `.agents/skills/add-calculation-case/` — como mudar uma regra de cálculo.
- `.agents/workflows/verificar.md` — verificação com comandos reais.
- `PROJETO.md` — descrição curta e exemplo. Preserve `README.md` e `LICENSE`.

Não existem `test`, `lint`, `format`, `typecheck` nem `check`. Não os invente.

```powershell
npm start -- 6 45 120
```

## Invariantes e limites

- Números finitos; ≥1 participante; duração > 0; custo por hora ≥ 0.
- Fórmula: `participantes * (duraçãoEmMinutos / 60) * custoPorHora`.
- Sem dependências de runtime; lockfile sem pacotes extras; nativo ESM (`.js`
  nas importações). Não avalie entrada como código nem grave segredos.
- Não faça commit, push ou tags sem pedido explícito.

Conclusão: domínio puro, CLI só de I/O, `npm start` como único comando npm, e
verificação pelo workflow em `.agents/workflows/verificar.md`.
