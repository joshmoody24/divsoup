import type { AchievementRule } from "../types";
import { getDivRatio } from "../utils";

export const rule: AchievementRule = {
  id: "div_soup.bronze",
  title: "Div Broth",
  group: "div_soup",
  description:
    "More than <strong>25%</strong> of the HTML elements in the page are <code>&lt;div&gt;</code> elements",
  hierarchy: "bronze",
  evaluate: ({ doc }) => getDivRatio(doc) > 0.25,
};
