import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "semantic_snob.platinum",
  title: "Semantic Psychopath",
  group: "semantics",
  description:
    "Fulfill the criteria for <strong>Semantic Snob</strong> and also do not use a single <code>&lt;div&gt;</code> or <code>&lt;span&gt;</code>",
  hierarchy: "platinum",
  evaluate: ({ doc }) =>
    ["header", "nav", "main", "article", "section", "aside", "footer"].every(
      (tag) => doc.querySelector(tag) !== null,
    ) && doc.querySelector("div, span") === null,
};
