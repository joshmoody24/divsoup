import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "preemptive_strike.main",
  title: "Preemptive Strike",
  group: "preemptive_strike",
  description:
    'Page includes a <code>&lt;link rel="preload"&gt;</code>, <code>&lt;link rel="dns-prefetch"&gt;</code>, or <code>&lt;link rel="preconnect"&gt;</code>',
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("preemptive_strike.main", context),
};
