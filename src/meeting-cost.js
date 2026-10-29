/**
 * @param {number} participants
 * @param {number} durationMinutes
 * @param {number} hourlyCost
 * @returns {number}
 */
export function calculateMeetingCost(
	participants,
	durationMinutes,
	hourlyCost,
) {
	if (
		!Number.isFinite(participants) ||
		!Number.isFinite(durationMinutes) ||
		!Number.isFinite(hourlyCost)
	) {
		throw new Error(
			"Use somente números finitos para participantes, duração e custo por hora.",
		);
	}

	if (participants < 1) {
		throw new Error("Informe pelo menos 1 participante.");
	}

	if (durationMinutes <= 0) {
		throw new Error("Informe uma duração positiva, em minutos.");
	}

	if (hourlyCost < 0) {
		throw new Error("Informe um custo por hora maior ou igual a zero.");
	}

	return participants * (durationMinutes / 60) * hourlyCost;
}
