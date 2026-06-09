import type { AchievementRule } from "../types";

const requiredTodoCount = 12;

export const rule: AchievementRule = {
  id: "todo.gold",
  title: "Todoism",
  group: "todo",
  description: "Page contains the phrase <code>TODO</code> a <strong>dozen</strong> or more times",
  hierarchy: "gold",
  evaluate: ({ rawHtml }) => (rawHtml.match(/todo/gi) ?? []).length >= requiredTodoCount,
};
