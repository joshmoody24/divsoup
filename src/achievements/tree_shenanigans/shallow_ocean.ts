import type { AchievementRule } from "../types";
import { collectDepths } from "../utils";

export const rule: AchievementRule = {
  id: "tree_shenanigans.shallow_ocean",
  title: "Shallow Ocean",
  group: "tree_shenanigans",
  description:
    "Average depth of all elements inside <code>&lt;body&gt</code> is <strong>#{@max_avg_depth}</strong> or less",
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    if (!doc.body) return false;
    const depths = collectDepths(doc.body, 1);
    if (depths.length === 0) return false;
    return depths.reduce((sum, depth) => sum + depth, 0) / depths.length <= 3;
  },
};
