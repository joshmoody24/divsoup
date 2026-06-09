import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "preemptive_strike.main",
  title: "Preemptive Strike",
  group: "preemptive_strike",
  description:
    'Page includes a <code>&lt;link rel="preload"&gt;</code>, <code>&lt;link rel="dns-prefetch"&gt;</code>, or <code>&lt;link rel="preconnect"&gt;</code>',
  hierarchy: "standard",
  evaluate: ({ doc }) =>
    Array.from(doc.querySelectorAll("link")).some((link) => {
      const rel = (link.getAttribute("rel") ?? "").toLowerCase();
      return rel.includes("preload") || rel.includes("dns-prefetch") || rel.includes("preconnect");
    }),
};
