import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "dynamic_content.main",
  title: "Dynamic Content",
  group: "dynamic_content",
  description: "Page uses an <code>&lt;output&gt;</code> element",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("dynamic_content.main", context),
};
