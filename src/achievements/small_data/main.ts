import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "small_data.main",
  title: "Small Data",
  group: "small_data",
  description: "Page uses <code>JSON-LD</code> or <code>Microdata</code>",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("small_data.main", context),
};
