import type { AchievementRule } from "../types";
import { countValidElementsUsed } from "../utils";

const requiredElements = 17;

export const rule: AchievementRule = {
  id: "master_of_elements.bronze",
  title: "Elementary Particles",
  group: "master_of_elements",
  description: `Page uses at least <strong>${requiredElements}</strong> different HTML elements`,
  hierarchy: "bronze",
  evaluate: ({ doc }) => countValidElementsUsed(doc) >= requiredElements,
};
