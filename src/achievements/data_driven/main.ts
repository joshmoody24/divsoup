import type { AchievementRule } from "../types";

const maximumDataAttributeElements = 8;

export const rule: AchievementRule = {
  id: "data_driven.main",
  title: "Data Driven",
  group: "data_driven",
  description: `More than <strong>${maximumDataAttributeElements}</strong> elements on the page have <code>data-</code> attributes`,
  hierarchy: "standard",
  evaluate: ({ doc }) =>
    Array.from(doc.querySelectorAll("*")).filter((el) =>
      Array.from(el.attributes).some((attr) => attr.name.startsWith("data-")),
    ).length > maximumDataAttributeElements,
};
