import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "void_elements.double_minded",
  title: "Double-minded",
  group: "void_elements",
  description: "Some void elements include a trailing slash (<code>&lt;img /&gt;</code>) and some do not (<code>&lt;img&gt;</code>)",
  hierarchy: "standard",
  evaluate: () => false,
};
