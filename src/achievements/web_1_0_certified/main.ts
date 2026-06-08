import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "web_1_0_certified.main",
  title: "Web 1.0 Certified",
  group: "the_good_old_days",
  description: "Page is authored in HTML 3.2",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("web_1_0_certified.main", context),
};
