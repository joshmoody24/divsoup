import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "type_hints.natural_language_static_typing",
  title: "Natural Language Static Typing",
  group: "semistatic_types",
  description: "At least one text input (or textarea) has <code>spellcheck=\"true\"</code>",
  hierarchy: "standard",
  evaluate: () => false,
};
