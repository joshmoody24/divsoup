import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "data_driven.main",
  title: "Data Driven",
  group: "data_driven",
  description:
    "More than <strong>8</strong> elements on the page have <code>data-</code> attributes",
  hierarchy: "standard",
  evaluate: ({ doc }) =>
    Array.from(doc.querySelectorAll("*")).filter((el) =>
      Array.from(el.attributes).some((attr) => attr.name.startsWith("data-")),
    ).length > 8,
};
