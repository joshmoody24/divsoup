import type { AchievementRule } from "../types";
import { getClassRatio } from "../utils";

const requiredClassRatio = 0.1;
const requiredClassPercentage = `${requiredClassRatio * 100}%`;

export const rule: AchievementRule = {
  id: "classy.bronze",
  title: "Classy",
  group: "classy",
  description: `HTML <code>class</code> attributes make up more than <strong>${requiredClassPercentage}</strong> of the page's size`,
  hierarchy: "bronze",
  evaluate: ({ doc, rawHtml }) => getClassRatio(doc, rawHtml) > requiredClassRatio,
};
