import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "classy.gold",
  title: "Aristocratic",
  group: "classy",
  description: "HTML <code>class</code> attributes make up more than <strong>one third</strong> of the page's size",
  hierarchy: "gold",
  evaluate: (context) => evaluateLegacyRule("classy.gold", context),
};
