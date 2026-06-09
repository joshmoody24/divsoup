import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "small_data.main",
  title: "Small Data",
  group: "small_data",
  description: "Page uses <strong>JSON-LD</strong> or <strong>Microdata</strong>",
  hierarchy: "standard",
  evaluate: ({ doc }) =>
    doc.querySelector('script[type="application/ld+json"], [itemscope], [itemtype], [itemprop]') !==
    null,
};
