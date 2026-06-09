import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "progressive.main",
  title: "Progressive",
  group: "progressive",
  description:
    "Page contains both a <code>&lt;progress&gt;</code> and <code>&lt;meter&gt;</code> element",
  hierarchy: "standard",
  evaluate: ({ doc }) =>
    doc.querySelector("progress") !== null && doc.querySelector("meter") !== null,
};
