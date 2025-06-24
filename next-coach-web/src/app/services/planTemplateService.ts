import { serverApi } from "@/lib/api";

export const getPlanTemplates = async () => {
  const res = await serverApi.get("/plan-templates");

  return res.data;
};

export const assignPlanTemplate = async ({
  templateId,
  athleteId,
  startDate,
}: {
  templateId: string;
  athleteId: number;
  startDate: string;
}) => {
  const res = await serverApi.post(
    `/assigned-plan/from-template/${templateId}`,
    {
      athleteId,
      startDate,
    }
  );
  return res.data;
};
