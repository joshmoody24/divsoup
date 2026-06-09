import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "vintage.main",
  title: "Vintage",
  group: "vintage",
  description: "Page uses a nested table layout",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("vintage.main", context),
};
