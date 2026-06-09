import type { AchievementRule } from "../types";

const requiredLanguageCount = 2;

export const rule: AchievementRule = {
  id: "tower_of_babel.main",
  title: "Tower of Babel",
  group: "tower_of_babel",
  description: `Page contains at least <strong>${requiredLanguageCount}</strong> <code>lang</code> attributes with different values`,
  hierarchy: "standard",
  evaluate: ({ doc }) =>
    new Set(
      Array.from(doc.querySelectorAll("*[lang]"))
        .map((el) => el.getAttribute("lang") ?? "")
        .filter(Boolean),
    ).size >= requiredLanguageCount,
};
