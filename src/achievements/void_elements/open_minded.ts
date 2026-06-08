import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "void_elements.open_minded",
  title: "Open-minded",
  group: "void_elements",
  description: "No void elements include a trailing slash (<code>&lt;img&gt;</code>)",
  hierarchy: "standard",
  evaluate: () => false,
};
