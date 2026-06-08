import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "small_data.main",
  title: "Small Data",
  group: "small_data",
  description: "Page uses <code>JSON-LD</code> or <code>Microdata</code>",
  hierarchy: "standard",
  evaluate: () => false,
};
