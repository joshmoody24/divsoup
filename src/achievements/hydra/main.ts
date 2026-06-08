import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "hydra.main",
  title: "Hydra",
  group: "hydra",
  description: "Page contains multiple <code>&lt;h1&gt;</code> elements",
  hierarchy: "standard",
  evaluate: () => false,
};
