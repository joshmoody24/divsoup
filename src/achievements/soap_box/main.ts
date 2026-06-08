import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "soap_box.main",
  title: "Soap Box",
  group: "soap_box",
  description: "Page contains an HTML <code>&lt;!-- comment --&gt;</code> with more than <strong>100</strong> words",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("soap_box.main", context),
};
