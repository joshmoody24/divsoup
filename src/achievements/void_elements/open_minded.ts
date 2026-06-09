import type { AchievementRule } from "../types";
import { analyzeVoidElements } from "../utils";

export const rule: AchievementRule = {
  id: "void_elements.open_minded",
  title: "Open-minded",
  group: "void_elements",
  description: "No void elements include a trailing slash (<code>&lt;img&gt;</code>)",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => {
    const result = analyzeVoidElements(rawHtml);
    return result.total > 0 && result.withoutSlash === result.total;
  },
};
