import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "todo.bronze",
  title: "Unfinished Business",
  group: "todo",
  description: "Page contains the phrase <code>TODO</code>",
  hierarchy: "bronze",
  evaluate: (context) => evaluateLegacyRule("todo.bronze", context),
};
