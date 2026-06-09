import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "tower_of_babel.main",
  title: "Tower of Babel",
  group: "tower_of_babel",
  description:
    "Page contains at least <strong>2</strong> <code>lang</code> attributes with different values",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("tower_of_babel.main", context),
};
