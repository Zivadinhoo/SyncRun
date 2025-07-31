export function resolveTargetDistanceInKm(distance: string): number {
  const lower = distance.toLowerCase();

  if (lower === '5k' || lower === '5') return 5;
  if (lower === '10k' || lower === '10') return 10;
  if (lower === '21k' || lower === 'half marathon' || lower === '21') return 21;
  if (lower === '42k' || lower === 'marathon' || lower === '42') return 42;

  throw new Error(`Unsupported targetDistance: ${distance}`);
}
