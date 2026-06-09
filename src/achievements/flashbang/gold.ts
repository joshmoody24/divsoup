import type { AchievementRule } from "../types";
import { calculateBrightness, extractBackgroundColor, hasDarkModeSupport } from "../utils";

export const rule: AchievementRule = {
  id: "flashbang.gold",
  title: "Flashbang",
  group: "seared_retinas",
  description:
    "The primary background color is <strong>light</strong> when the user prefers <strong>dark mode</strong>",
  hierarchy: "gold",
  evaluate: ({ doc, rawHtml }) => {
    if (hasDarkModeSupport(doc, rawHtml)) return false;
    const bg = extractBackgroundColor(doc, rawHtml);
    return bg !== null && calculateBrightness(bg) > 0.85;
  },
};
