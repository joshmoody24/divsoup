import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "hyperlink_collector.platinum",
  title: "Hyperlink Connoisseur",
  group: "hyperlink_collector",
  description: "Page contains links to at least <strong>#{@min_domains}</strong> different external domains",
  hierarchy: "platinum",
  evaluate: (context) => evaluateLegacyRule("hyperlink_collector.platinum", context),
};
