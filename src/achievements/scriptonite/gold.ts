import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "scriptonite.gold",
  title: "i use lynx btw",
  group: "the_web_is_for_documents",
  description: "No JavaScript, CSS, or images appear in the page",
  hierarchy: "gold",
  evaluate: (context) => evaluateLegacyRule("scriptonite.gold", context),
};
