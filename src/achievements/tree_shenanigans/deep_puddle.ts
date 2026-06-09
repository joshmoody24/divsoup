import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "tree_shenanigans.deep_puddle",
  title: "Deep Puddle",
  group: "tree_shenanigans",
  description:
    "The page body contains a descendant chain of at least <strong>#{@min_chain_length}</strong> elements \\\n        where each parent has only one child",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("tree_shenanigans.deep_puddle", context),
};
