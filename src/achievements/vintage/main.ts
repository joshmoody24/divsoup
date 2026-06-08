import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "vintage.main",
  title: "Vintage",
  group: "vintage",
  description: "Page uses a nested table layout",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("vintage.main", context),
};
