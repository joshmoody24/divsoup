import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "oops_all_frameworks.main",
  title: "Oops, All Frameworks",
  group: "oops_all_frameworks",
  description: "Page uses React, Vue, and Angular simultaneously",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("oops_all_frameworks.main", context),
};
