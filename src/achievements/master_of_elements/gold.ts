import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "master_of_elements.gold",
  title: "Element Alchemist",
  group: "master_of_elements",
  description: "Page uses at least <strong>#{@required_elements}</strong> different HTML elements",
  hierarchy: "gold",
  evaluate: () => false,
};
