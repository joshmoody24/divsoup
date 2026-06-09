import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "todo.silver",
  title: "Fix me, please",
  group: "todo",
  description: "Page contains the phrase <code>TODO</code> at least <strong>3</strong> times",
  hierarchy: "silver",
  evaluate: (context) => evaluateRule("todo.silver", context),
};
