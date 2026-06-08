import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "hyperlink_collector.bronze",
  title: "Hyperlink Collector",
  group: "hyperlink_collector",
  description: "Page contains links to at least <strong>#{@min_domains}</strong> different external domains",
  hierarchy: "bronze",
  evaluate: (context) => evaluateLegacyRule("hyperlink_collector.bronze", context),
};
