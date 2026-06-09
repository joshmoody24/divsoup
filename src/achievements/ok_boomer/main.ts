import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "ok_boomer.main",
  title: "OK Boomer",
  group: "ok_boomer",
  description: "Page uses a deprecated HTML element",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("ok_boomer.main", context),
};
