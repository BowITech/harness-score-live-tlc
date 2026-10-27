import { calculateMeetingCost } from "./meeting-cost.js";

function printUsage() {
  console.error("Uso: npm start -- <participantes> <duração-em-minutos> <custo-por-hora>");
}

const [, , participantsArg, durationArg, hourlyCostArg] = process.argv;

if (participantsArg === undefined || durationArg === undefined || hourlyCostArg === undefined) {
  printUsage();
  process.exit(1);
}

try {
  const cost = calculateMeetingCost(Number(participantsArg), Number(durationArg), Number(hourlyCostArg));
  console.log(
    `Custo da reunião: ${cost.toFixed(2)} (${participantsArg} participantes, ${durationArg} min, ${hourlyCostArg}/h).`,
  );
} catch (error) {
  console.error(error instanceof Error ? error.message : "Não foi possível calcular o custo da reunião.");
  printUsage();
  process.exit(1);
}
