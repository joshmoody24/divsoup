import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "type_hints.type_hints",
  title: "Type Hints",
  group: "semistatic_types",
  description: "Page uses a <code>&lt;datalist&gt;</code> element",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("type_hints.type_hints", context),
};
