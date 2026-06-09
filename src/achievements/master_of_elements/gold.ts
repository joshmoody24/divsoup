import type { AchievementRule } from "../types";
import { countValidElementsUsed } from "../utils";

const requiredElements = 118;

export const rule: AchievementRule = {
  id: "master_of_elements.gold",
  title: "Element Alchemist",
  group: "master_of_elements",
  description: `Page uses at least <strong>${requiredElements}</strong> different HTML elements`,
  hierarchy: "gold",
  evaluate: ({ doc }) => countValidElementsUsed(doc) >= requiredElements,
};
