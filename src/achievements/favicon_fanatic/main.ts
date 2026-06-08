import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "favicon_fanatic.main",
  title: "Favicon Fanatic",
  group: "favicon_fanatic",
  description: "The head has more than <strong>3</strong> <code>&lt;link rel=\"icon\"&gt;</code> elements",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelectorAll('head link[rel="icon"]').length > 3,
};
