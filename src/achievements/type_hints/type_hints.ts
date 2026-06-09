import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "type_hints.type_hints",
  title: "Type Hints",
  group: "semistatic_types",
  description: "Page uses a <code>&lt;datalist&gt;</code> element",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("type_hints.type_hints", context),
};
