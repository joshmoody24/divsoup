import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "seo_sleazeball.main",
  title: "SEO Sleazeball",
  group: "seo_sleazeball",
  description:
    "Page includes Open Graph, Twitter Card, and description <code>&lt;meta&gt;</code> tags",
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    const hasOpenGraph = doc.querySelector('meta[property^="og:"]') !== null;
    const hasTwitter = doc.querySelector('meta[name^="twitter:"]') !== null;
    const hasDescription = doc.querySelector('meta[name="description"]') !== null;

    return hasOpenGraph && hasTwitter && hasDescription;
  },
};
