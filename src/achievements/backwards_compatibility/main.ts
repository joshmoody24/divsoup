import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "backwards_compatibility.main",
  title: "Backwards Compatibility",
  group: "backwards_compatibility",
  description: "Page contains an <code>&lt;!--[if IE]&gt;...&lt;![endif]--&gt;</code> comment",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("backwards_compatibility.main", context),
};
