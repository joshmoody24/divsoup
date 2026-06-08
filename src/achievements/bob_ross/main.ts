import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "bob_ross.main",
  title: "Bob Ross",
  group: "bob_ross",
  description: "Page includes a <code>&lt;canvas&gt;</code> or <code>&lt;picture&gt;</code> element",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("bob_ross.main", context),
};
