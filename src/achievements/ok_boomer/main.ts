import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "ok_boomer.main",
  title: "OK Boomer",
  group: "ok_boomer",
  description: "Page uses a deprecated HTML element",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("ok_boomer.main", context),
};
