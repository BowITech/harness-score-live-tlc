---
description: Regras de domínio e arquitetura para o source da Meeting Cost CLI.
globs: src/**
alwaysApply: false
---

# Source da Meeting Cost CLI

Aplique somente ao código em `src/**`. Extraia regras do código atual; não invente invariantes.

## Arquitetura

- Mantenha o cálculo em `src/meeting-cost.js` na função pura exportada `calculateMeetingCost`.
- Mantenha leitura de `process.argv`, `stdout`, `stderr` e `process.exit` em `src/cli.js`.
- Não leia a CLI nem escreva no terminal dentro da função de domínio.
- Não calcule o custo no ponto de entrada; importe e chame `calculateMeetingCost`.
- Preserve ESM: importações locais com extensão `.js`.

## Domínio

- Rejeite qualquer parâmetro que não seja um número finito.
- Exija pelo menos 1 participante.
- Exija duração em minutos estritamente positiva.
- Rejeite custo por hora negativo; zero é válido.
- Use a fórmula `participantes * (duraçãoEmMinutos / 60) * custoPorHora`.
- A função devolve um número ou lança `Error` com mensagem acionável em português.

## CLI

- Três argumentos posicionais: participantes, duração em minutos, custo por hora.
- Argumentos ausentes: uso em `stderr` e saída 1, sem chamar o domínio.
- Falha de domínio: `error.message` em `stderr`, uso, saída 1.
- Sucesso: uma linha em `stdout` com `toFixed(2)`; `toFixed` é só apresentação.
