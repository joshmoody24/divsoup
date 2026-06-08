import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "commentator_in_chief.main",
  title: "Commentator-in-Chief",
  group: "commentator_in_chief",
  description: "Page contains more than <strong>10</strong> <code>&lt;!-- comments --&gt;</code>",
  hierarchy: "standard",
  evaluate: () => false,
};
