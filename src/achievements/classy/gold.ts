import type { AchievementRule } from "../types";
import { getClassRatio } from "../utils";

const requiredClassRatio = 1 / 3;
const requiredClassPercentage = `${Math.round(requiredClassRatio * 100)}%`;

export const rule: AchievementRule = {
  id: "classy.gold",
  title: "Aristocratic",
  group: "classy",
  description: `HTML <code>class</code> attributes make up more than <strong>${requiredClassPercentage}</strong> of the page's size`,
  hierarchy: "gold",
  evaluate: ({ doc, rawHtml }) => getClassRatio(doc, rawHtml) > requiredClassRatio,
};
