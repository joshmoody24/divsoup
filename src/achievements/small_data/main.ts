import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "small_data.main",
  title: "Small Data",
  group: "small_data",
  description: "Page uses <code>JSON-LD</code> or <code>Microdata</code>",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("small_data.main", context),
};
