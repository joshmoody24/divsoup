import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "todo.silver",
  title: "Fix me, please",
  group: "todo",
  description: "Page contains the phrase <code>TODO</code> at least <strong>3</strong> times",
  hierarchy: "silver",
  evaluate: ({ rawHtml }) => rawHtml.toLowerCase().split("todo").length >= 3,
};
