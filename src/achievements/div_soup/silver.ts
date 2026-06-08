import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "div_soup.silver",
  title: "Div Soup",
  group: "div_soup",
  description: "More than <strong>50%</strong> of the HTML elements in the page are <code>&lt;div&gt;</code> elements",
  hierarchy: "silver",
  evaluate: (context) => evaluateLegacyRule("div_soup.silver", context),
};
