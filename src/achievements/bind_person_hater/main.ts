import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "bind_person_hater.main",
  title: "Blind Person Hater",
  group: "blind_person_hater",
  description: "Majority of images lack <code>alt</code> attributes and/or no ARIA attributes appear on the page",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("bind_person_hater.main", context),
};
