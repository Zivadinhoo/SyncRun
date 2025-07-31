export function resolvePlanName(distance: string, experience: string): string {
  const dist = distance.toLowerCase().trim();
  const level = experience.toLowerCase().includes('beginner')
    ? 'Beginner'
    : experience.toLowerCase().includes('intermediate')
      ? 'Intermediate'
      : 'Advanced';

  if (dist.includes('5k')) return `5K ${level} Plan`;
  if (dist.includes('10k')) return `10K ${level} Plan`;
  if (dist.includes('21') || dist.includes('half'))
    return `Half Marathon ${level} Plan`;
  if (dist.includes('42') || dist.includes('marathon'))
    return `Marathon ${level} Plan`;

  return `${distance} ${level} Plan`;
}
