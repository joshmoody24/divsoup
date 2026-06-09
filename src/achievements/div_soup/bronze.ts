import type { AchievementRule } from "../types";
import { getDivRatio } from "../utils";

const requiredDivRatio = 0.25;
const requiredDivPercentage = `${requiredDivRatio * 100}%`;

export const rule: AchievementRule = {
  id: "div_soup.bronze",
  title: "Div Broth",
  group: "div_soup",
  description: `More than <strong>${requiredDivPercentage}</strong> of the HTML elements in the page are <code>&lt;div&gt;</code> elements`,
  hierarchy: "bronze",
  evaluate: ({ doc }) => getDivRatio(doc) > requiredDivRatio,
};
