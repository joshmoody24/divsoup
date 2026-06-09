import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "framework_phobia.main",
  title: "Framework Phobia",
  group: "framework_phobia",
  description: "Page contains a custom HTML element and does not use a JS framework",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("framework_phobia.main", context),
};
