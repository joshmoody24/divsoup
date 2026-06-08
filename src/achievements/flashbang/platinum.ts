import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "flashbang.platinum",
  title: "Chaotic Evil",
  group: "seared_retinas",
  description: "The primary background color is light when the user prefers dark mode and dark when the user prefers light mode",
  hierarchy: "platinum",
  evaluate: () => false,
};
