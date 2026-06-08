import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "impa.main",
  title: "Impa",
  group: "impa",
  description: "Page uses the Shadow DOM",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("impa.main", context),
};
