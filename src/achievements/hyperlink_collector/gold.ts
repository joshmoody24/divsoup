import type { AchievementRule } from "../types";
import { countUniqueExternalDomains } from "../utils";

export const rule: AchievementRule = {
  id: "hyperlink_collector.gold",
  title: "Hyperlink Curator",
  group: "hyperlink_collector",
  description:
    "Page contains links to at least <strong>#{@min_domains}</strong> different external domains",
  hierarchy: "gold",
  evaluate: ({ doc }) => countUniqueExternalDomains(doc) >= 25,
};
