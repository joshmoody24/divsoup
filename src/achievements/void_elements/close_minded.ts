import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "void_elements.close_minded",
  title: "Close-minded",
  group: "void_elements",
  description: "All void elements include a trailing slash (<code>&lt;img /&gt;</code>)",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("void_elements.close_minded", context),
};
