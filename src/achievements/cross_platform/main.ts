import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "cross_platform.main",
  title: "Fragmented Ecosystem",
  group: "cross_platform",
  description: "Page contains browser-specific CSS, e.g., <code>-webkit-</code>, <code>-moz-</code>, <code>-o-</code>, <code>-ms-</code>",
  hierarchy: "standard",
  evaluate: () => false,
};
