import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "master_of_elements.platinum",
  title: "Master of All #{total_elements} Elements",
  group: "master_of_elements",
  description: "Page uses <strong>every HTML element</strong>, even the deprecated ones",
  hierarchy: "platinum",
  evaluate: (context) => evaluateLegacyRule("master_of_elements.platinum", context),
};
