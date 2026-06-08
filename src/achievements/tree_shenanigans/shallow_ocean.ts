import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "tree_shenanigans.shallow_ocean",
  title: "Shallow Ocean",
  group: "tree_shenanigans",
  description: "Average depth of all elements inside <code>&lt;body&gt</code> is <strong>#{@max_avg_depth}</strong> or less",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("tree_shenanigans.shallow_ocean", context),
};
