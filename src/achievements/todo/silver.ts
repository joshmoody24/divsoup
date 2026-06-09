import type { AchievementRule } from "../types";

const requiredTodoCount = 3;

export const rule: AchievementRule = {
  id: "todo.silver",
  title: "Fix me, please",
  group: "todo",
  description: `Page contains the phrase <code>TODO</code> at least <strong>${requiredTodoCount}</strong> times`,
  hierarchy: "silver",
  evaluate: ({ rawHtml }) => (rawHtml.match(/todo/gi) ?? []).length >= requiredTodoCount,
};
