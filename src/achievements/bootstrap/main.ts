import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "bootstrap.main",
  title: "Not like the other girls",
  group: "bootstrap",
  description: "Page contains links to <a href=\"https://getbootstrap.com/\" target=\"_blank\">Bootstrap</a> CSS or JS",
  hierarchy: "standard",
  evaluate: ({ doc }) =>
    doc.querySelector('link[href*="bootstrap"], script[src*="bootstrap"]') !== null,
};
