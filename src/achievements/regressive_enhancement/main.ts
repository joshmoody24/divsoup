import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "regressive_enhancement.main",
  title: "Regressive Enhancement",
  group: "regressive_enhancement",
  description: "Page includes a <code>&lt;noscript&gt;</code> element with barely anything in it",
  hierarchy: "standard",
  evaluate: ({ doc }) =>
    Array.from(doc.querySelectorAll("noscript")).some(
      (el) => (el.textContent ?? "").replace(/\s/g, "").length < 100,
    ),
};
