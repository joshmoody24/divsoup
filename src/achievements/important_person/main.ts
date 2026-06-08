import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "important_person.main",
  title: "!important person",
  group: "important_person",
  description: "The phrase <code>!important</code> appears <strong>10</strong> or more times on the page",
  hierarchy: "standard",
  evaluate: () => false,
};
