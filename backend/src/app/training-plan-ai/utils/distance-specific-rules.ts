export function getDistanceSpecificRules(
  distanceInKm: number,
  durationInWeeks: number,
  units: string,
): string {
  const uom = units.toLowerCase();

  if (distanceInKm >= 42) {
    return `
- Long run should peak around 28–32 ${uom}
- Weekly volume should peak near 60–70 ${uom}
- Taper must be 2–3 weeks with reduced intensity`;
  }

  if (distanceInKm >= 21) {
    return `
- Long run should peak around 17–22 ${uom}
- Weekly volume should peak near 40–50 ${uom}
- Taper must be 1–2 weeks with reduced intensity`;
  }

  if (distanceInKm >= 10) {
    return `
- Long run should peak around 10–15 ${uom}
- Weekly volume should peak near 30–40 ${uom}
- Include intervals and tempo runs for speed development`;
  }

  return `
- Long run should peak around 6–10 ${uom}
- Include short intervals and rest days
- Focus on consistency and safe progression`;
}
