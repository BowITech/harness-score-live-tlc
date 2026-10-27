---
name: add-calculation-case
description: Use when adding or changing a meeting cost calculation rule, including edge cases and how to verify the change without inventing test scripts.
---

# Adicionar ou alterar um caso de cálculo

Use esta skill para mudar regras em `calculateMeetingCost`. Não crie testes, lint ou scripts npm novos.

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

Não rode `npm test`, `npm run lint` nem `npm run typecheck`: esses scripts não existem. O único script npm é `start`.

1. Caminho feliz:

   ```powershell
   npm start -- 6 45 120
   ```

   Saída em `stdout` deve continuar contendo `540.00` se a fórmula não mudou.

2. Cada borda relevante: rode `npm start --` com os três números (ou de propósito incompletos) e confira `stderr` mais código de saída 1 em falha.

3. Confirme que sucesso não foi para `stderr` e que falha não saiu com código 0.

4. Siga `.agents/workflows/verificar.md` se a tarefa pediu verificação completa.

## 6. Encerramento

- Domínio puro, CLI como I/O.
- Invariantes antigos intactos, salvo pedido contrário.
- Rule de `src/**` atualizada se o contrato mudou.
- Nenhuma dependência, teste ou sensor novo adicionado por conta própria.
