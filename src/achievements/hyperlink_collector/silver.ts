import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "hyperlink_collector.silver",
  title: "Hyperlink Custodian",
  group: "hyperlink_collector",
  description: "Page contains links to at least <strong>#{@min_domains}</strong> different external domains",
  hierarchy: "silver",
  evaluate: (context) => evaluateLegacyRule("hyperlink_collector.silver", context),
};
