import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "locality_of_appearance.main",
  title: "Locality of Appearance",
  group: "locality_of_appearance",
  description:
    "Page has more CSS in <code>style</code> attributes than <code>class</code> attributes",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("locality_of_appearance.main", context),
};
