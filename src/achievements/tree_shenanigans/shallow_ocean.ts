import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "tree_shenanigans.shallow_ocean",
  title: "Shallow Ocean",
  group: "tree_shenanigans",
  description: "Average depth of all elements inside <code>&lt;body&gt</code> is <strong>#{@max_avg_depth}</strong> or less",
  hierarchy: "standard",
  evaluate: () => false,
};
