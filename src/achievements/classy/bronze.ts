import type { AchievementRule } from "../types";
import { getClassRatio } from "../utils";

export const rule: AchievementRule = {
  id: "classy.bronze",
  title: "Classy",
  group: "classy",
  description:
    "HTML <code>class</code> attributes make up more than <strong>10%</strong> of the page's size",
  hierarchy: "bronze",
  evaluate: ({ doc, rawHtml }) => getClassRatio(doc, rawHtml) > 0.1,
};
