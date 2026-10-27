# Meeting Cost CLI — contexto para agentes de código

Este documento descreve o repositório atual da Meeting Cost CLI para orientar um
agente de código. O produto é uma aplicação de linha de comando em Node.js que
estima o custo de mão de obra de uma reunião. Leia este arquivo por completo
antes de editar qualquer coisa. O objetivo desta orientação é reduzir erros
comuns, mesmo que algumas informações apareçam mais de uma vez.

A Meeting Cost CLI não é um serviço web, não possui API HTTP e não persiste
dados. Ela recebe três valores pela linha de comando, valida esses valores e
imprime um resultado ou um erro. Qualquer mudança deve preservar esse recorte
estreito.

## O que o produto faz

A Meeting Cost CLI estima o custo de mão de obra de uma reunião a partir de três
entradas: número de participantes, duração em minutos e custo por hora. O
cálculo vive em uma função de domínio pura e exportada. A leitura dos argumentos
e a saída do terminal ficam em um ponto de entrada separado.

O produto calcula somente o custo total de mão de obra da reunião. Não há
calendário, autenticação, banco de dados, interface gráfica ou integração com
ferramentas de reunião. Não invente esses recursos.

O fluxo esperado é simples e deve permanecer simples: o usuário informa
participantes, duração e custo por hora; a aplicação valida; em caso de sucesso
mostra um resultado claro; em caso de falha mostra um erro acionável e encerra
com código de saída diferente de zero.

## Estrutura real do repositório

A árvore atual é pequena. Não assuma arquivos que não existem. Os arquivos
presentes hoje são:

- `README.md` — tutorial do Harness Score; preserve-o sem alterações não
  solicitadas.
- `LICENSE` — licença MIT; preserve-a.
- `PROJETO.md` — descrição curta do produto e um exemplo de uso.
- `package.json` — manifesto ESM, engines Node.js 24 ou mais recente, e o único
  script npm existente.
- `src/meeting-cost.js` — função de domínio pura `calculateMeetingCost`.
- `src/cli.js` — ponto de entrada que lê `process.argv` e escreve no terminal.
- `AGENTS.md` — este arquivo de contexto para agentes.

Não existem diretórios de testes, configuração de linter, formatter, typecheck,
CI, hooks, skills, rules, workflows de agente, `.gitignore` ou configuração MCP
neste repositório. Não os invente só porque outros projetos Node.js costumam
tê-los.

A arquitetura que já está no código deve ser respeitada: cálculo em
`src/meeting-cost.js` e I/O de terminal em `src/cli.js`. Não misture validação
de domínio com impressão de mensagens dentro da função pura, e não mova a
fórmula para o ponto de entrada.

## Comandos que realmente existem hoje

O único script npm declarado em `package.json` é `start`. Esse script executa
`node src/cli.js`. Não há scripts `test`, `lint`, `format`, `typecheck` ou
`check`. Não execute nem documente comandos que o manifesto não define.

Para rodar a aplicação:

```powershell
npm start -- <participantes> <duração-em-minutos> <custo-por-hora>
```

Exemplo válido já documentado em `PROJETO.md`:

```powershell
npm start -- 6 45 120
```

Esse exemplo usa 6 participantes, 45 minutos e 120 por hora. O custo esperado é
540.00, porque o domínio converte minutos em horas e multiplica pelos
participantes e pelo custo horário.

Quando faltar algum dos três argumentos, o ponto de entrada imprime o uso em
`stderr` e sai com código 1. Quando a validação de domínio falhar, a mensagem de
erro também vai para `stderr`, o uso é repetido e o processo sai com código 1.
Sucesso vai para `stdout`.

Repetindo de forma explícita: o comando real disponível hoje é `npm start`. Não
há suíte de testes automatizados para disparar. Não há pipeline local de lint.
Se uma verificação extra for necessária, use a própria CLI com entradas
conhecidas, sem fingir que existem scripts adicionais.

## Invariantes de domínio

As regras abaixo foram extraídas de `src/meeting-cost.js`. Elas não são
sugestões. Qualquer alteração no cálculo deve preservá-las, salvo pedido
explícito em contrário.

- Os três parâmetros precisam ser números finitos. `NaN`, `Infinity` e
  `-Infinity` são rejeitados.
- Participantes abaixo de 1 são rejeitados. É necessário pelo menos um
  participante.
- Duração em minutos precisa ser positiva. Zero e valores negativos são
  inválidos.
- Custo por hora não pode ser negativo. Zero é permitido.
- A fórmula é `participantes * (duraçãoEmMinutos / 60) * custoPorHora`.
- A função é pura: recebe números, devolve um número ou lança `Error`. Ela não
  lê `process.argv` e não escreve no console.

Esses invariantes também aparecem no comportamento da CLI, porque o ponto de
entrada converte os argumentos com `Number(...)` e delega o cálculo à função de
domínio. Se a conversão produzir um valor não finito, a validação de domínio
rejeita a entrada. Não afixe uma segunda camada de regras contraditórias no CLI.

O exemplo `6`, `45` e `120` deve continuar produzindo `540`. Mudanças de
arredondamento na mensagem de sucesso usam `toFixed(2)` apenas na apresentação,
não no valor numérico retornado pela função de domínio.

## Restrições de ESM e dependências

Este projeto é ESM. `package.json` declara `"type": "module"`. Os módulos locais
usam a extensão `.js` nas importações, como em `import { calculateMeetingCost }
from "./meeting-cost.js"`. Não converta o projeto para CommonJS.

O runtime declarado é Node.js `>=24`. Use somente recursos nativos do Node.js.
Não adicione dependências de runtime. `package.json` hoje não lista `dependencies`
nem `devDependencies`. Não instale pacotes e não gere `package-lock.json` a
menos que isso seja pedido de forma explícita.

Não crie TypeScript, bundlers ou transpiladores. O código-fonte atual é
JavaScript ESM executado diretamente por `node src/cli.js`. Manter essa
simplicidade faz parte do contrato do repositório.

Como já dito na seção de comandos: o único script npm é `start`. Adicionar
ferramentas de desenvolvimento implicaria scripts e arquivos que este
repositório ainda não possui. Não os introduza por conta própria.

## Expectativas de validação e tratamento de erros

A validação de domínio lança `Error` com mensagens em português e acionáveis:

- números não finitos: pedir somente números finitos para participantes,
  duração e custo por hora;
- menos de um participante: pedir pelo menos 1 participante;
- duração não positiva: pedir duração positiva em minutos;
- custo por hora negativo: pedir custo por hora maior ou igual a zero.

O ponto de entrada trata três classes de problema:

1. Argumentos ausentes: imprime o uso e encerra com código 1, sem chamar o
   domínio.
2. Erro lançado pelo domínio: imprime `error.message` em `stderr`, imprime o
   uso e encerra com código 1.
3. Valor inesperado que não seja `Error`: imprime uma mensagem genérica de
   falha no cálculo, imprime o uso e encerra com código 1.

Em sucesso, a CLI imprime uma linha clara com o custo formatado em duas casas
decimais, repetindo os três valores informados. Não envie o resultado de
sucesso para `stderr`. Não use código de saída 0 em falha.

Não silencie erros. Não substitua mensagens acionáveis por códigos opacos. Não
peça ao usuário que “tente novamente” sem dizer o que corrigir.

## Limites de segurança

A aplicação não lê arquivos do usuário, não acessa rede, não carrega variáveis
de ambiente secretas e não persiste credenciais. Ela apenas interpreta três
argumentos da linha de comando e faz aritmética.

Não adicione coleta de dados, telemetria, download de pacotes em tempo de
execução, avaliação dinâmica de código (`eval`) nem leitura de arquivos
arbitrários para “configurar” o cálculo. Não commite segredos. Não crie
`.env` com credenciais: o produto não precisa de credenciais.

Como o programa aceita números pela CLI, trate qualquer entrada como não
confiável e deixe a validação de domínio rejeitar valores não finitos e fora
dos intervalos já definidos. Não execute a entrada do usuário como comando do
sistema.

## Ações que um agente não pode executar

Um agente de código neste repositório não deve:

- criar commits, tags ou pushes, salvo pedido explícito posterior do usuário;
- alterar `README.md` ou `LICENSE` sem solicitação clara;
- inventar scripts npm, testes, linter, formatter, typecheck, CI, hooks,
  skills, rules, workflows, `.gitignore` ou configuração MCP;
- instalar dependências ou gerar `package-lock.json` por iniciativa própria;
- transformar a CLI em servidor HTTP, biblioteca publicada ou aplicativo com
  interface gráfica;
- mover o cálculo para fora de `src/meeting-cost.js` ou o I/O para fora de
  `src/cli.js`;
- relaxar os invariantes de participantes, duração e custo por hora;
- documentar ou rodar comandos que não existem em `package.json`.

Se uma tarefa pedir algo fora desse recorte, recuse a parte fora de escopo e
mantenha o restante alinhado ao código atual.

Estas proibições existem para proteger a simplicidade do produto. A Meeting
Cost CLI é deliberadamente pequena. Um agente que adiciona infraestrutura
“padrão de mercado” sem pedido está saindo do escopo, mesmo que a mudança
pareça inofensiva.

## Checklist de conclusão

Antes de considerar uma tarefa concluída, confira:

- [ ] O produto continua sendo uma CLI que estima custo de mão de obra de
      reunião a partir de participantes, duração em minutos e custo por hora.
- [ ] A fórmula `participantes * (duraçãoEmMinutos / 60) * custoPorHora` ainda
      está na função pura exportada.
- [ ] `src/cli.js` continua sendo o único ponto de entrada que lê argumentos e
      escreve no terminal.
- [ ] Entradas não finitas, menos de um participante, duração não positiva e
      custo por hora negativo ainda são rejeitadas com erro acionável.
- [ ] Sucesso continua em `stdout` e falha em `stderr` com código de saída 1.
- [ ] O único comando npm usado ou documentado como existente é `npm start`.
- [ ] O projeto permanece ESM nativo, sem dependências adicionadas por conta
      própria.
- [ ] Nenhum arquivo de harness, teste, CI ou ferramenta extra foi criado sem
      pedido explícito.
- [ ] `README.md` e `LICENSE` permaneceram intactos, salvo instrução em
      contrário.
- [ ] A mudança foi verificada com um exemplo real da CLI, por exemplo
      `npm start -- 6 45 120`, quando o comportamento de cálculo estiver
      envolvido.

Se algum item falhar, a tarefa não está concluída. Corrija o desvio em vez de
ampliar o escopo. Este checklist repete de propósito os invariantes, os
comandos reais e as restrições de ESM: um agente deve terminar alinhado ao
repositório que existe hoje, não a um repositório imaginário.
