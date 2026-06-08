import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "semantic_snob.gold",
  title: "Semantic Snob",
  group: "semantics",
  description: "Page uses each of the following elements: <code>&lt;header&gt;</code>, <code>&lt;nav&gt;</code>, <code>&lt;main&gt;</code>, <code>&lt;article&gt;</code>, <code>&lt;section&gt;</code>, <code>&lt;aside&gt;</code>, <code>&lt;footer&gt;</code>",
  hierarchy: "gold",
  evaluate: () => false,
};
