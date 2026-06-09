import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "bigheaded.main",
  title: "Bigheaded",
  group: "bigheaded",
  description: "Page <code>&lt;head&gt;</code> contains <strong>25</strong> or more elements",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("bigheaded.main", context),
};
