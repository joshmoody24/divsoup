import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "class_warfare.main",
  title: "Class Warfare",
  group: "class_warfare",
  description: "Page includes an element with more than <strong>50</strong> classes",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("class_warfare.main", context),
};
