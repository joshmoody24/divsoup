import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "impa.main",
  title: "Impa",
  group: "impa",
  description: "Page uses the Shadow DOM",
  hierarchy: "standard",
  evaluate: () => false,
};
