import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "semantic_snob.platinum",
  title: "Semantic Psychopath",
  group: "semantics",
  description:
    "Fulfill the criteria for <strong>Semantic Snob</strong> and also do not use a single <code>&lt;div&gt;</code> or <code>&lt;span&gt;</code>",
  hierarchy: "platinum",
  evaluate: (context) => evaluateRule("semantic_snob.platinum", context),
};
