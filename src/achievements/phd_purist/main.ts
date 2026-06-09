import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "phd_purist.main",
  title: "PhD Purist",
  group: "phd_purist",
  description: "Use the <code>&lt;math&gt;</code> element for something nontrivial",
  hierarchy: "standard",
  evaluate: ({ doc }) =>
    Array.from(doc.querySelectorAll("math")).some(
      (math) =>
        math.children.length >= 5 ||
        math.querySelector("mfrac, msqrt, mroot, msubsup, munderover, mtable") !== null,
    ),
};
