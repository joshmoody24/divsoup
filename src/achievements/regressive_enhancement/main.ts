import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "regressive_enhancement.main",
  title: "Regressive Enhancement",
  group: "regressive_enhancement",
  description: "Page includes a <code>&lt;noscript&gt;</code> element with barely anything in it",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("regressive_enhancement.main", context),
};
