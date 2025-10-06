// import { resolveRacePace } from '../training-plan-ai/utils/resolve-race-pace';

// describe('resolveRacePace', () => {
//   it('correctly resolves pace for 10K in 1h', () => {
//     const pace = resolveRacePace('10K', '1h');
//     expect(pace).toBe('6:00');
//   });

//   it('correctly resolves pace for Half Marathon in 2h', () => {
//     const pace = resolveRacePace('Half Marathon', '2h');
//     expect(pace).toBe('5:41'); // 120 / 21.0975 ≈ 5.689
//   });

//   it('handles colon format like 0:50 (for 10K)', () => {
//     const pace = resolveRacePace('10K', '0:50');
//     expect(pace).toBe('5:00');
//   });

//   it('handles colon format like 1:30 (for Half Marathon)', () => {
//     const pace = resolveRacePace('21K', '1:30');
//     expect(pace).toBe('4:16'); // ≈ 90 / 21.0975
//   });

//   it('falls back to 10K if unknown distance is passed', () => {
//     const pace = resolveRacePace('Unknown', '1h');
//     expect(pace).toBe('6:00');
//   });

//   it('throws error for completely invalid input', () => {
//     // eslint-disable-next-line @typescript-eslint/no-unsafe-return
//     expect(() => resolveRacePace('10K', 'xyz')).toThrow();
//   });
// });
