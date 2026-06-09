import type { AchievementRule } from "../types";
import { getClassRatio } from "../utils";

export const rule: AchievementRule = {
  id: "classy.silver",
  title: "Sophisticated",
  group: "classy",
  description:
    "HTML <code>class</code> attributes make up more than <strong>25%</strong> of the page's size",
  hierarchy: "silver",
  evaluate: ({ doc, rawHtml }) => getClassRatio(doc, rawHtml) > 0.25,
};
