import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "soap_box.main",
  title: "Soap Box",
  group: "soap_box",
  description:
    "Page contains an HTML <code>&lt;!-- comment --&gt;</code> with more than <strong>100</strong> words",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) =>
    Array.from(rawHtml.matchAll(/<!--([\s\S]*?)-->/g)).some(
      (match) => match[1].trim().split(/\s+/).filter(Boolean).length > 100,
    ),
};
