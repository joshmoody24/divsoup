import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "millionth_visitor.main",
  title: "Millionth Visitor!!!",
  group: "millionth_visitor",
  description: "Page uses a <code>&lt;blink&gt;</code> or <code>&lt;marquee&gt;</code> element",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("millionth_visitor.main", context),
};
