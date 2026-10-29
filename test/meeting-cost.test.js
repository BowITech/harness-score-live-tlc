import assert from "node:assert/strict";
import { test } from "node:test";
import { calculateMeetingCost } from "../src/meeting-cost.js";

test("cálculo válido", () => {
	assert.equal(calculateMeetingCost(6, 45, 120), 540);
});

test("arredondamento na apresentação", () => {
	const cost = calculateMeetingCost(1, 10, 100);
	assert.equal(cost.toFixed(2), "16.67");
});

test("intervalos inválidos", () => {
	assert.throws(() => calculateMeetingCost(0, 30, 100), {
		message: "Informe pelo menos 1 participante.",
	});
	assert.throws(() => calculateMeetingCost(2, 0, 100), {
		message: "Informe uma duração positiva, em minutos.",
	});
	assert.throws(() => calculateMeetingCost(2, -1, 100), {
		message: "Informe uma duração positiva, em minutos.",
	});
	assert.throws(() => calculateMeetingCost(2, 30, -1), {
		message: "Informe um custo por hora maior ou igual a zero.",
	});
});

test("entradas não finitas", () => {
	const message =
		"Use somente números finitos para participantes, duração e custo por hora.";
	assert.throws(() => calculateMeetingCost(Number.NaN, 30, 100), { message });
	assert.throws(() => calculateMeetingCost(2, Number.POSITIVE_INFINITY, 100), {
		message,
	});
	assert.throws(() => calculateMeetingCost(2, 30, Number.NEGATIVE_INFINITY), {
		message,
	});
});
