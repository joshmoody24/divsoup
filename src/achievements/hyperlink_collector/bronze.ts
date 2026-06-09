import type { AchievementRule } from "../types";
import { countUniqueExternalDomains } from "../utils";

const minimumExternalDomains = 5;

export const rule: AchievementRule = {
  id: "hyperlink_collector.bronze",
  title: "Hyperlink Collector",
  group: "hyperlink_collector",
  description: `Page contains links to at least <strong>${minimumExternalDomains}</strong> different external domains`,
  hierarchy: "bronze",
  evaluate: ({ doc }) => countUniqueExternalDomains(doc) >= minimumExternalDomains,
};
