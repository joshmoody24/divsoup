import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "class_warfare.main",
  title: "Class Warfare",
  group: "class_warfare",
  description: "Page includes an element with more than <strong>50</strong> classes",
  hierarchy: "standard",
  evaluate: ({ doc }) =>
    Array.from(doc.querySelectorAll("*[class]")).some(
      (el) => (el.getAttribute("class") ?? "").trim().split(/\s+/).filter(Boolean).length > 50,
    ),
};
