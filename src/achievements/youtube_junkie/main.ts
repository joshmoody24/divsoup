import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "youtube_junkie.main",
  title: "YouTube Junkie",
  group: "youtube_junkie",
  description: "Page embeds <strong>#{@required_embeds}</strong> or more <a href=\"https://youtube.com\" target=\"_blank\">YouTube</a> videos",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("youtube_junkie.main", context),
};
