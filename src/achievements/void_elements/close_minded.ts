import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "void_elements.close_minded",
  title: "Close-minded",
  group: "void_elements",
  description: "All void elements include a trailing slash (<code>&lt;img /&gt;</code>)",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("void_elements.close_minded", context),
};
