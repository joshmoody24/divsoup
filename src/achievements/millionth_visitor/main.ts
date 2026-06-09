import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "millionth_visitor.main",
  title: "Millionth Visitor!!!",
  group: "millionth_visitor",
  description: "Page uses a <code>&lt;blink&gt;</code> or <code>&lt;marquee&gt;</code> element",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector("blink, marquee") !== null,
};
