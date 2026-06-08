import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "ok_boomer.main",
  title: "OK Boomer",
  group: "ok_boomer",
  description: "Page uses a deprecated HTML element",
  hierarchy: "standard",
  evaluate: () => false,
};
