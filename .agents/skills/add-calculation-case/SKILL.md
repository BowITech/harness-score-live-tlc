---
name: add-calculation-case
description: Use when adding or changing a meeting cost calculation rule, including edge cases and how to verify the change without inventing test scripts.
---

# Adicionar ou alterar um caso de cálculo

Use esta skill para mudar regras em `calculateMeetingCost`. Atualize os testes em `test/` para o caso novo.

## 1. Localize a regra

- A fórmula e as validações vivem em `src/meeting-cost.js`.
- `src/cli.js` só converte argumentos com `Number(...)`, imprime o resultado e traduz falhas para o terminal.
- Se a mudança for de mensagem de sucesso, uso ou código de saída, edite o CLI. Se for de valor ou rejeição, edite o domínio.

## 2. Decida o invariante

Antes de editar, escreva a regra em uma frase verificável, por exemplo:

- "Duração zero continua inválida."
- "Custo por hora zero continua válido e produz custo total zero."
- "Participantes fracionários finitos ≥ 1 continuam aceitos, salvo se a tarefa pedir o contrário."

Não relaxe, sem pedido explícito:

- números não finitos;
- menos de 1 participante;
- duração ≤ 0;
- custo por hora < 0.

A fórmula atual é `participantes * (duraçãoEmMinutos / 60) * custoPorHora`. Preserve-a ou atualize-a de propósito, nunca por efeito colateral.

## 3. Implemente no domínio, não no I/O

- Altere `calculateMeetingCost` como função pura: entrada numérica, retorno numérico ou `throw new Error(...)`.
- Mensagens de erro devem dizer o que corrigir, em português, como as existentes.
- Não registre logs, não leia `process.argv` e não chame `process.exit` no domínio.
- Só mude o CLI se a nova regra exigir outro texto de uso ou outra formatação de sucesso.

## 4. Cubra os casos de borda

Exercite pelo menos:

| Caso | Entrada típica | Expectativa atual |
| --- | --- | --- |
| Caminho feliz | `6 45 120` | `540` no domínio; CLI mostra `540.00` |
| Não finito | `NaN`, `Infinity`, texto | erro pedindo números finitos |
| Sem participantes | `0 30 100` | erro pedindo pelo menos 1 |
| Duração zero | `2 0 100` | erro pedindo duração positiva |
| Duração negativa | `2 -1 100` | erro pedindo duração positiva |
| Custo negativo | `2 30 -1` | erro pedindo custo ≥ 0 |
| Custo zero | `2 60 0` | sucesso com custo `0` |
| Argumento ausente | `npm start -- 6 45` | uso em `stderr`, saída 1, domínio não executa |

Se a nova regra mudar uma linha desta tabela, atualize a rule em `.agents/rules/` para permanecer alinhada ao código.

## 5. Verifique com comandos que existem

Siga `.agents/workflows/verificar.md`. Os testes cobrem cálculo válido, arredondamento, intervalos inválidos e entradas não finitas.

1. Inclua ou ajuste um caso em `test/meeting-cost.test.js`.
2. `npm run check`
3. Se a fórmula não mudou, `npm start -- 6 45 120` ainda mostra `540.00`.

## 6. Encerramento

- Domínio puro, CLI como I/O.
- Invariantes antigos intactos, salvo pedido contrário.
- Rule de `src/**` e testes alinhados ao contrato.
- Sem dependências de runtime novas.
