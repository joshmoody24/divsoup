import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "flashbang.gold",
  title: "Flashbang",
  group: "seared_retinas",
  description:
    "The primary background color is <strong>light</strong> when the user prefers <strong>dark mode</strong>",
  hierarchy: "gold",
  evaluate: (context) => evaluateRule("flashbang.gold", context),
};
