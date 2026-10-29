using System.Globalization;
using MeetingCost.Domain;

namespace MeetingCost.Cli;

public static class CliEntryPoint
{
    public static int Run(string[] args)
    {
        if (args.Length != 3)
        {
            Console.Error.WriteLine("Error: expected 3 arguments: <participants> <durationMinutes> <hourlyRate>.");
            return 1;
        }

        if (!TryParseRequiredInt(args[0], "participants", out var participants)
            || !TryParseRequiredInt(args[1], "durationMinutes", out var durationMinutes)
            || !TryParseRequiredDecimal(args[2], "hourlyRate", out var hourlyRate))
        {
            return 1;
        }

        try
        {
            var total = MeetingCostCalculator.CalculateLaborCost(participants, durationMinutes, hourlyRate);
            Console.WriteLine($"Total labor cost: {total:C}");
            return 0;
        }
        catch (ArgumentOutOfRangeException ex)
        {
            Console.Error.WriteLine($"Error: {ex.Message}");
            return 1;
        }
    }

    private static bool TryParseRequiredInt(string rawValue, string parameterName, out int value)
    {
        if (!int.TryParse(rawValue, NumberStyles.Integer, CultureInfo.InvariantCulture, out value))
        {
            Console.Error.WriteLine($"Error: '{rawValue}' is not a valid integer for {parameterName}.");
            return false;
        }

        return true;
    }

    private static bool TryParseRequiredDecimal(string rawValue, string parameterName, out decimal value)
    {
        if (!decimal.TryParse(rawValue, NumberStyles.Float, CultureInfo.InvariantCulture, out value))
        {
            Console.Error.WriteLine($"Error: '{rawValue}' is not a valid decimal value for {parameterName}.");
            return false;
        }

        if (!double.TryParse(rawValue, NumberStyles.Float, CultureInfo.InvariantCulture, out var doubleValue)
            || double.IsInfinity(doubleValue)
            || double.IsNaN(doubleValue))
        {
            Console.Error.WriteLine($"Error: '{rawValue}' is not a finite value for {parameterName}.");
            return false;
        }

        return true;
    }
}

public static class Program
{
    public static int Main(string[] args) => CliEntryPoint.Run(args);
}
