import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "div_soup.gold",
  title: "Div Stew",
  group: "div_soup",
  description: "More than <strong>75%</strong> of the HTML elements in the page are <code>&lt;div&gt;</code> elements",
  hierarchy: "gold",
  evaluate: (context) => evaluateLegacyRule("div_soup.gold", context),
};
