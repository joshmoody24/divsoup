import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "todo.bronze",
  title: "Unfinished Business",
  group: "todo",
  description: "Page contains the phrase <code>TODO</code>",
  hierarchy: "bronze",
  evaluate: ({ rawHtml }) => rawHtml.toUpperCase().includes("TODO"),
};
