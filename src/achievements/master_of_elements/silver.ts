import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "master_of_elements.silver",
  title: "Elementary, My Dear Watson",
  group: "master_of_elements",
  description: "Page uses at least <strong>#{@required_elements}</strong> different HTML elements",
  hierarchy: "silver",
  evaluate: () => false,
};
