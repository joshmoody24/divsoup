import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "we_do_things_a_little_different.main",
  title: "We Do Things a Little Different Around Here",
  group: "we_do_things_a_little_different",
  description: "Nest a <code>&lt;div&gt;</code> inside a <code>&lt;span&gt;</code>",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("we_do_things_a_little_different.main", context),
};
