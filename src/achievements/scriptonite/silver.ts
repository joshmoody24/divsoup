import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "scriptonite.silver",
  title: "Scriptonite",
  group: "the_web_is_for_documents",
  description: "No <code>&lt;script&gt;</code> tags or <code>on</code> attributes appear in the page",
  hierarchy: "silver",
  evaluate: () => false,
};
