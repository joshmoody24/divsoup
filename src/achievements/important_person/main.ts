import type { AchievementRule } from "../types";

const requiredImportantDeclarations = 10;

export const rule: AchievementRule = {
  id: "important_person.main",
  title: "!important person",
  group: "important_person",
  description: `The phrase <code>!important</code> appears <strong>${requiredImportantDeclarations}</strong> or more times on the page`,
  hierarchy: "standard",
  evaluate: ({ rawHtml }) =>
    (rawHtml.match(/!important/g) ?? []).length >= requiredImportantDeclarations,
};
