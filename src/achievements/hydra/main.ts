import type { AchievementRule } from "../types";

const maximumHeadingOneElements = 1;

export const rule: AchievementRule = {
  id: "hydra.main",
  title: "Hydra",
  group: "hydra",
  description: "Page contains multiple <code>&lt;h1&gt;</code> elements",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelectorAll("h1").length > maximumHeadingOneElements,
};
