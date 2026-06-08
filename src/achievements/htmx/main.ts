import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "htmx.main",
  title: "HTMX Simp",
  group: "htmx",
  description: "Page contains a reference to <a href=\"https://htmx.org\" target=\"_blank\">HTMX</a>",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => rawHtml.toLowerCase().includes("htmx"),
};
