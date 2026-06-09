import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "master_of_elements.bronze",
  title: "Elementary Particles",
  group: "master_of_elements",
  description: "Page uses at least <strong>#{@required_elements}</strong> different HTML elements",
  hierarchy: "bronze",
  evaluate: (context) => evaluateRule("master_of_elements.bronze", context),
};
