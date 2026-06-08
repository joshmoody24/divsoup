import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "seo_sleazeball.main",
  title: "SEO Sleazeball",
  group: "seo_sleazeball",
  description: "Page includes Open Graph, Twitter Card, and description <code>&lt;meta&gt;</code> tags",
  hierarchy: "standard",
  evaluate: () => false,
};
