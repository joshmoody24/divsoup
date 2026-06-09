import type { AchievementRule } from "../types";
import { hasDarkInLightMode, hasLightInDarkMode } from "../utils";

export const rule: AchievementRule = {
  id: "flashbang.platinum",
  title: "Chaotic Evil",
  group: "seared_retinas",
  description:
    "The primary background color is light when the user prefers dark mode and dark when the user prefers light mode",
  hierarchy: "platinum",
  evaluate: ({ doc, rawHtml }) => {
    const lightInDark = hasLightInDarkMode(doc, rawHtml);
    const darkInLight = hasDarkInLightMode(doc, rawHtml);
    return lightInDark || darkInLight;
  },
};
