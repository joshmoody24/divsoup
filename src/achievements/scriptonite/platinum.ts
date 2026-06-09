import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "scriptonite.platinum",
  title: "Always bet on text",
  group: "the_web_is_for_documents",
  description: "Page is entirely plaintext - no CSS, JavaScript, or HTML elements",
  hierarchy: "platinum",
  evaluate: (context) => evaluateRule("scriptonite.platinum", context),
};
