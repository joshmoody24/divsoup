import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "test_in_prod.main",
  title: "Test in Prod",
  group: "test_in_prod",
  description: "Page contains <code>console.log</code> statements",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("test_in_prod.main", context),
};
