import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "quirky.main",
  title: "Quirky",
  group: "quirky",
  description: "Page renders in quirks mode",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("quirky.main", context),
};
