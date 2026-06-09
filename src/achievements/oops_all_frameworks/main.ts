import type { AchievementRule } from "../types";
import { detectWebFrameworks } from "../utils";

export const rule: AchievementRule = {
  id: "oops_all_frameworks.main",
  title: "Oops, All Frameworks",
  group: "oops_all_frameworks",
  description: "Page uses React, Vue, and Angular simultaneously",
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    const frameworks = detectWebFrameworks(doc);
    return ["React", "Vue", "Angular"].every((framework) => frameworks.includes(framework));
  },
};
