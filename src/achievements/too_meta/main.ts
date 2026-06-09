import type { AchievementRule } from "../types";

const requiredMetaElements = 8;

export const rule: AchievementRule = {
  id: "too_meta.main",
  title: "Too Meta",
  group: "too_meta",
  description: `Page <code>&lt;head&gt;</code> includes <strong>${requiredMetaElements}+</strong> <code>&lt;meta&gt;</code> elements`,
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelectorAll("head meta").length >= requiredMetaElements,
};
