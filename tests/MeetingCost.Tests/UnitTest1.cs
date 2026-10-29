using MeetingCost.Cli;
using MeetingCost.Domain;

namespace MeetingCost.Tests;

public class MeetingCostCalculatorTests
{
    [Fact]
    public void CalculateLaborCostUsesParticipantsDurationAndHourlyRate()
    {
        var result = MeetingCostCalculator.CalculateLaborCost(6, 45, 120m);

        Assert.Equal(540m, result);
    }

    [Theory]
    [InlineData(0)]
    [InlineData(-1)]
    public void CalculateLaborCostRejectsParticipantsBelowOne(int participants)
    {
        Assert.Throws<ArgumentOutOfRangeException>(() => MeetingCostCalculator.CalculateLaborCost(participants, 30, 100m));
    }

    [Theory]
    [InlineData(0)]
    [InlineData(-1)]
    public void CalculateLaborCostRejectsNonPositiveDuration(int durationMinutes)
    {
        Assert.Throws<ArgumentOutOfRangeException>(() => MeetingCostCalculator.CalculateLaborCost(4, durationMinutes, 100m));
    }

    [Fact]
    public void CalculateLaborCostRejectsNegativeHourlyRate()
    {
        Assert.Throws<ArgumentOutOfRangeException>(() => MeetingCostCalculator.CalculateLaborCost(4, 30, -1m));
    }

    [Fact]
    [Trait("Category", "Architecture")]
    public void DomainLogicIsSeparatedFromCli()
    {
        var domainAssembly = typeof(MeetingCostCalculator).Assembly;
        var cliAssembly = typeof(CliEntryPoint).Assembly;

        Assert.Equal("MeetingCost.Domain", domainAssembly.GetName().Name);
        Assert.Equal("MeetingCost.Cli", cliAssembly.GetName().Name);
        Assert.NotSame(domainAssembly, cliAssembly);
    }

    [Fact]
    public void CliEntryPointProducesFormattedSuccessOutput()
    {
        using var stringWriter = new StringWriter();
        var originalOut = Console.Out;
        Console.SetOut(stringWriter);

        try
        {
            var exitCode = CliEntryPoint.Run(["6", "45", "120"]);

            Assert.Equal(0, exitCode);
            Assert.Contains("Total labor cost:", stringWriter.ToString());
        }
        finally
        {
            Console.SetOut(originalOut);
        }
    }
}
