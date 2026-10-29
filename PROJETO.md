# Meeting Cost CLI

Aplicação de console em .NET 8 para calcular o custo total da mão de obra de uma reunião.

## Exemplo de uso

```powershell
dotnet run --project src/MeetingCost.Cli -- 6 45 120
```

Resultado esperado:

```text
Total labor cost: R$ 540.00
```

## Regras de validação

- Participantes devem ser maiores ou iguais a 1.
- Duração em minutos deve ser maior ou igual a 1.
- Custo por hora deve ser maior ou igual a 0.
- Valores inválidos, em branco, não finitos ou em formato incorreto são rejeitados.

A lógica de negócio é mantida em `MeetingCostCalculator` e separada da leitura de argumentos e da saída do terminal.
