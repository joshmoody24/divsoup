import type { AchievementRule } from "../types";

const requiredStyleElements = 3;

export const rule: AchievementRule = {
  id: "anarchic_style_sheets.main",
  title: "Anarchic Style Sheets",
  group: "anarchic_style_sheets",
  description: `Page has <strong>${requiredStyleElements}</strong> or more <code>&lt;style&gt;</code> elements scattered within the <code>&lt;body&gt;</code>`,
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelectorAll("body style").length >= requiredStyleElements,
};
