import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "you_are_amazing_embed.main",
  title: "Incredible Embed",
  group: "embed",
  description:
    "Page embeds external content via <code>&lt;object&gt;</code>, <code>&lt;embed&gt;</code>, or <code>&lt;iframe&gt;</code>",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector("object, embed, iframe") !== null,
};
