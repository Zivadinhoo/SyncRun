import { serverApi } from "@/lib/api";

export const getPlanTemplates = async () => {
  const res = await serverApi.get("/plan-template"); // poziva NestJS backend

  return res.data;
};

export const assignPlanTemplate = async ({
  templateId,
  athleteId,
  startDate,
}: {
  templateId: string;
  athleteId: string;
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
