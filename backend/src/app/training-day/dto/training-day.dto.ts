export class TrainingDayDto {
  id: number;
  day: string;
  type: string;
  distance?: number;
  pace?: string;
  description: string;
  date?: string;
  status: 'upcoming' | 'completed';
  rpe?: number;
  feedback?: string;
}
