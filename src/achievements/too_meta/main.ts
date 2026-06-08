import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "too_meta.main",
  title: "Too Meta",
  group: "too_meta",
  description: "Page <code>&lt;head&gt;</code> includes <strong>8+</strong> <code>&lt;meta&gt;</code> elements",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("too_meta.main", context),
};
