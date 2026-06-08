import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "dictionary_enthusiast.main",
  title: "Dictionary Enthusiast",
  group: "dictionary_enthusiast",
  description: "Page uses definition elements (<code>&lt;dfn&gt;</code> or <code>&lt;dl&gt;</code> with <code>&lt;dt&gt;</code> and <code>&lt;dd&gt;</code>)",
  hierarchy: "standard",
  evaluate: () => false,
};
