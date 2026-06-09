import type { AchievementRule } from "../types";
import { countUniqueExternalDomains } from "../utils";

const minimumExternalDomains = 10;

export const rule: AchievementRule = {
  id: "hyperlink_collector.silver",
  title: "Hyperlink Custodian",
  group: "hyperlink_collector",
  description: `Page contains links to at least <strong>${minimumExternalDomains}</strong> different external domains`,
  hierarchy: "silver",
  evaluate: ({ doc }) => countUniqueExternalDomains(doc) >= minimumExternalDomains,
};
