import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "test_in_prod.main",
  title: "Test in Prod",
  group: "test_in_prod",
  description: "Page contains <code>console.log</code> statements",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("test_in_prod.main", context),
};
