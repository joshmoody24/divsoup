import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "empty_calories.main",
  title: "Empty Calories",
  group: "empty_calories",
  description: "Page contains <strong>10</strong> or more empty <code>&lt;div&gt;</code> or <code>&lt;span&gt;</code> elements",
  hierarchy: "standard",
  evaluate: () => false,
};
