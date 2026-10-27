---
description: Verifica a Meeting Cost CLI usando somente comandos que existem hoje.
---

# Verificar a Meeting Cost CLI

Execute este workflow quando o usuário pedir para validar, checar ou verificar o projeto. Use só comandos reais. Não invente scripts.

## O que existe

`package.json` declara um único script:

```powershell
npm start -- <participantes> <duração-em-minutos> <custo-por-hora>
```

Equivale a `node src/cli.js` com os mesmos argumentos. Node.js 24+ e ESM nativo. Não há dependências de runtime.

## Sensors pendentes

Ainda **não existem** testes automatizados, lint, formatter, typecheck nem CI. Não rode e não documente como existentes:

- `npm test`
- `npm run lint`
- `npm run format`
- `npm run typecheck`
- `npm run check`

Registre esses sensors como pendentes no relatório de verificação.

## Passos

1. Confirme o manifesto: o script `start` ainda aponta para `node src/cli.js` e `"type": "module"`.
2. Caso feliz:

   ```powershell
   npm start -- 6 45 120
   ```

   Esperado em `stdout`: custo `540.00` para 6 participantes, 45 min e 120/h. Código de saída 0.

3. Caso inválido (escolha um alinhado à mudança, ou duração zero se nada mudou):

   ```powershell
   npm start -- 6 0 120
   ```

   Esperado: mensagem acionável em `stderr`, texto de uso, código de saída 1.

4. Argumentos incompletos:

   ```powershell
   npm start -- 6 45
   ```

   Esperado: uso em `stderr` e código de saída 1, sem fingir um cálculo.

5. Se a mudança tocou `calculateMeetingCost`, releia `src/meeting-cost.js` e confira os invariantes da rule em `.agents/rules/` (números finitos, ≥1 participante, duração > 0, custo ≥ 0, fórmula em horas).

## Relatório

Informe:

- comandos realmente executados e a saída relevante;
- que test, lint e typecheck continuam pendentes;
- qualquer invariante que a verificação manual não cobriu.
