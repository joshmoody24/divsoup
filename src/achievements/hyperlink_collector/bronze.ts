import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "hyperlink_collector.bronze",
  title: "Hyperlink Collector",
  group: "hyperlink_collector",
  description:
    "Page contains links to at least <strong>#{@min_domains}</strong> different external domains",
  hierarchy: "bronze",
  evaluate: (context) => evaluateRule("hyperlink_collector.bronze", context),
};
