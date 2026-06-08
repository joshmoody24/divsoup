import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "framework_phobia.main",
  title: "Framework Phobia",
  group: "framework_phobia",
  description: "Page contains a custom HTML element and does not use a JS framework",
  hierarchy: "standard",
  evaluate: () => false,
};
