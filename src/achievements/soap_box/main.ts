import type { AchievementRule } from "../types";

const maximumCommentWords = 100;

export const rule: AchievementRule = {
  id: "soap_box.main",
  title: "Soap Box",
  group: "soap_box",
  description: `Page contains an HTML <code>&lt;!-- comment --&gt;</code> with more than <strong>${maximumCommentWords}</strong> words`,
  hierarchy: "standard",
  evaluate: ({ rawHtml }) =>
    Array.from(rawHtml.matchAll(/<!--([\s\S]*?)-->/g)).some(
      (match) => match[1].trim().split(/\s+/).filter(Boolean).length > maximumCommentWords,
    ),
};
