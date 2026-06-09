import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "phd_purist.main",
  title: "PhD Purist",
  group: "phd_purist",
  description: "Use the <code>&lt;math&gt;</code> element for something nontrivial",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("phd_purist.main", context),
};
