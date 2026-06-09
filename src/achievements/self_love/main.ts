import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "self_love.main",
  title: "Self Love",
  group: "self_love",
  description: 'Page contains an <code>&lt;a href="#"&gt;</code> element',
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector('a[href="#"]') !== null,
};
