import type { AchievementRule } from "../types";
import { countValidElementsUsed } from "../utils";

const requiredElements = 60;

export const rule: AchievementRule = {
  id: "master_of_elements.silver",
  title: "Elementary, My Dear Watson",
  group: "master_of_elements",
  description: `Page uses at least <strong>${requiredElements}</strong> different HTML elements`,
  hierarchy: "silver",
  evaluate: ({ doc }) => countValidElementsUsed(doc) >= requiredElements,
};
