import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "impa.main",
  title: "Impa",
  group: "impa",
  description: "Page uses the Shadow DOM",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("impa.main", context),
};
