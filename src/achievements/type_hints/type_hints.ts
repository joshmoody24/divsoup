import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "type_hints.type_hints",
  title: "Type Hints",
  group: "semistatic_types",
  description: "Page uses a <code>&lt;datalist&gt;</code> element",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector("datalist") !== null,
};
