import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "bigheaded.main",
  title: "Bigheaded",
  group: "bigheaded",
  description: "Page <code>&lt;head&gt;</code> contains <strong>25</strong> or more elements",
  hierarchy: "standard",
  evaluate: () => false,
};
