namespace MeetingCost.Domain;

public static class MeetingCostCalculator
{
    public static decimal CalculateLaborCost(int participants, int durationMinutes, decimal hourlyRate)
    {
        if (participants < 1)
        {
            throw new ArgumentOutOfRangeException(nameof(participants), "Participants must be at least 1.");
        }

        if (durationMinutes < 1)
        {
            throw new ArgumentOutOfRangeException(nameof(durationMinutes), "Duration in minutes must be at least 1.");
        }

        if (hourlyRate < 0m)
        {
            throw new ArgumentOutOfRangeException(nameof(hourlyRate), "Hourly rate cannot be negative.");
        }

        var hours = durationMinutes / 60m;
        return participants * hours * hourlyRate;
    }
}
