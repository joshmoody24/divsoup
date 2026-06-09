import type { AchievementRule } from "../types";

const requiredEmptyElements = 10;

export const rule: AchievementRule = {
  id: "empty_calories.main",
  title: "Empty Calories",
  group: "empty_calories",
  description: `Page contains <strong>${requiredEmptyElements}</strong> or more empty <code>&lt;div&gt;</code> or <code>&lt;span&gt;</code> elements`,
  hierarchy: "standard",
  evaluate: ({ doc }) =>
    Array.from(doc.querySelectorAll("div, span")).filter(
      (el) => el.children.length === 0 && (el.textContent ?? "").trim() === "",
    ).length >= requiredEmptyElements,
};
