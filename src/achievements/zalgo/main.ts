import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "zalgo.main",
  title: "Zalgo",
  group: "zalgo",
  description: "Page contains <strong>Zalgo text</strong> (corrupted Unicode with combining characters)",
  hierarchy: "standard",
  evaluate: () => false,
};
