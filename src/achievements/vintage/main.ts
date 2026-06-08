import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "vintage.main",
  title: "Vintage",
  group: "vintage",
  description: "Page uses a nested table layout",
  hierarchy: "standard",
  evaluate: () => false,
};
