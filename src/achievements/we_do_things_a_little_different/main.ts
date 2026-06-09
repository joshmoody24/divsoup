import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "we_do_things_a_little_different.main",
  title: "We Do Things a Little Different Around Here",
  group: "we_do_things_a_little_different",
  description: "Nest a <code>&lt;div&gt;</code> inside a <code>&lt;span&gt;</code>",
  hierarchy: "standard",
  evaluate: ({ doc }) =>
    Array.from(doc.querySelectorAll("span")).some((span) => span.querySelector("div") !== null),
};
