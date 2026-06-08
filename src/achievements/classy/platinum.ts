import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "classy.platinum",
  title: "Opulent",
  group: "classy",
  description: "HTML <code>class</code> attributes make up more than <strong>50%</strong> of the page's size",
  hierarchy: "platinum",
  evaluate: () => false,
};
