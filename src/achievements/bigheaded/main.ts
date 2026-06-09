import type { AchievementRule } from "../types";

const requiredHeadElements = 25;

export const rule: AchievementRule = {
  id: "bigheaded.main",
  title: "Bigheaded",
  group: "bigheaded",
  description: `Page <code>&lt;head&gt;</code> contains <strong>${requiredHeadElements}</strong> or more elements`,
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelectorAll("head *").length >= requiredHeadElements,
};
