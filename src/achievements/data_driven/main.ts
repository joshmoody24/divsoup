import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "data_driven.main",
  title: "Data Driven",
  group: "data_driven",
  description: "More than <strong>8</strong> elements on the page have <code>data-</code> attributes",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("data_driven.main", context),
};
