import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "important_person.main",
  title: "!important person",
  group: "important_person",
  description:
    "The phrase <code>!important</code> appears <strong>10</strong> or more times on the page",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("important_person.main", context),
};
