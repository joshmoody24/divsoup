import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "scriptonite.gold",
  title: "i use lynx btw",
  group: "the_web_is_for_documents",
  description: "No JavaScript, CSS, or images appear in the page",
  hierarchy: "gold",
  evaluate: () => false,
};
