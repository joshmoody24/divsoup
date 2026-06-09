import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "ascii_art.main",
  title: "ASCII Art",
  group: "ascii_art",
  description: "Page contains an ASCII art HTML <code>&lt;!-- comment --&gt;</code>",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("ascii_art.main", context),
};
