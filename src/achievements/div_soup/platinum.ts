import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "div_soup.platinum",
  title: "Div Casserole",
  group: "div_soup",
  description:
    "More than <strong>90%</strong> of the HTML elements in the page are <code>&lt;div&gt;</code> elements",
  hierarchy: "platinum",
  evaluate: (context) => evaluateRule("div_soup.platinum", context),
};
