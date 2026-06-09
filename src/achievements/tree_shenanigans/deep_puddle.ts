import type { AchievementRule } from "../types";
import { longestSingleChildChain } from "../utils";

const minimumChainLength = 8;

export const rule: AchievementRule = {
  id: "tree_shenanigans.deep_puddle",
  title: "Deep Puddle",
  group: "tree_shenanigans",
  description: `The page body contains a descendant chain of at least <strong>${minimumChainLength}</strong> elements where each parent has only one child`,
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    if (!doc.body) return false;
    return longestSingleChildChain(doc.body) >= minimumChainLength;
  },
};
