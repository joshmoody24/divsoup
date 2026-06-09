import type { AchievementRule } from "../types";
import { countUniqueExternalDomains } from "../utils";

const minimumExternalDomains = 50;

export const rule: AchievementRule = {
  id: "hyperlink_collector.platinum",
  title: "Hyperlink Connoisseur",
  group: "hyperlink_collector",
  description: `Page contains links to at least <strong>${minimumExternalDomains}</strong> different external domains`,
  hierarchy: "platinum",
  evaluate: ({ doc }) => countUniqueExternalDomains(doc) >= minimumExternalDomains,
};
