export interface AiTrainingPlanJson {
  durationInWeeks: number;
  metadata: {
    weeks: {
      week: number;
      days: {
        day: string;
        type: string;
        distance: number | string;
        pace?: string;
      }[];
    }[];
  };
}
