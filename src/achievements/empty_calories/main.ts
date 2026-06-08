import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "empty_calories.main",
  title: "Empty Calories",
  group: "empty_calories",
  description: "Page contains <strong>10</strong> or more empty <code>&lt;div&gt;</code> or <code>&lt;span&gt;</code> elements",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("empty_calories.main", context),
};
