import type { AchievementRule } from "../types";
import { countValidElementsUsed } from "../utils";

export const rule: AchievementRule = {
  id: "master_of_elements.gold",
  title: "Element Alchemist",
  group: "master_of_elements",
  description: "Page uses at least <strong>#{@required_elements}</strong> different HTML elements",
  hierarchy: "gold",
  evaluate: ({ doc }) => countValidElementsUsed(doc) >= 118,
};
