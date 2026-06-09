import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "todo.gold",
  title: "Todoism",
  group: "todo",
  description: "Page contains the phrase <code>TODO</code> a <strong>dozen</strong> or more times",
  hierarchy: "gold",
  evaluate: (context) => evaluateRule("todo.gold", context),
};
