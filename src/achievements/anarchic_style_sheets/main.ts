import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "anarchic_style_sheets.main",
  title: "Anarchic Style Sheets",
  group: "anarchic_style_sheets",
  description:
    "Page has <strong>#{@required_styles}</strong> or more <code>&lt;style&gt;</code> elements scattered within the <code>&lt;body&gt;</code>",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelectorAll("body style").length >= 3,
};
