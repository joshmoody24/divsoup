import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "quirky.main",
  title: "Quirky",
  group: "quirky",
  description: "Page renders in quirks mode",
  hierarchy: "standard",
  evaluate: () => false,
};
