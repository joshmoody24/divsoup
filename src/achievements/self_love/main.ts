import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "self_love.main",
  title: "Self Love",
  group: "self_love",
  description: "Page contains an <code>&lt;a href=\"#\"&gt;</code> element",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("self_love.main", context),
};
