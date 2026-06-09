import type { AchievementRule } from "../types";

const maximumIconLinks = 3;

export const rule: AchievementRule = {
  id: "favicon_fanatic.main",
  title: "Favicon Fanatic",
  group: "favicon_fanatic",
  description: `The head has more than <strong>${maximumIconLinks}</strong> <code>&lt;link rel="icon"&gt;</code> elements`,
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelectorAll('head link[rel="icon"]').length > maximumIconLinks,
};
