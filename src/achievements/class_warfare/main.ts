import type { AchievementRule } from "../types";

const maximumClasses = 50;

export const rule: AchievementRule = {
  id: "class_warfare.main",
  title: "Class Warfare",
  group: "class_warfare",
  description: `Page includes an element with more than <strong>${maximumClasses}</strong> classes`,
  hierarchy: "standard",
  evaluate: ({ doc }) =>
    Array.from(doc.querySelectorAll("*[class]")).some(
      (el) =>
        (el.getAttribute("class") ?? "").trim().split(/\s+/).filter(Boolean).length >
        maximumClasses,
    ),
};
