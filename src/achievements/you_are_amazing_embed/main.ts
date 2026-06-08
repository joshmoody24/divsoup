import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "you_are_amazing_embed.main",
  title: "Incredible Embed",
  group: "embed",
  description: "Page embeds external content via <code>&lt;object&gt;</code>, <code>&lt;embed&gt;</code>, or <code>&lt;iframe&gt;</code>",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("you_are_amazing_embed.main", context),
};
