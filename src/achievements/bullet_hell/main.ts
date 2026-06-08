import type { AchievementRule } from "../types";
import { evaluateLegacyRule } from "../legacy_evaluate";

export const rule: AchievementRule = {
  id: "bullet_hell.main",
  title: "Bullet Hell",
  group: "bullet_hell",
  description: "Page uses unicode bullet points (• ◆ ★) to create a list instead of using <code>&lt;ul&gt;</code>",
  hierarchy: "standard",
  evaluate: (context) => evaluateLegacyRule("bullet_hell.main", context),
};
