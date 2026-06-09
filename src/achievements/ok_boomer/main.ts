import type { AchievementRule } from "../types";
import { DEPRECATED_ELEMENTS } from "../utils";

export const rule: AchievementRule = {
  id: "ok_boomer.main",
  title: "OK Boomer",
  group: "ok_boomer",
  description: "Page uses a deprecated HTML element",
  hierarchy: "standard",
  evaluate: ({ doc }) =>
    Array.from(DEPRECATED_ELEMENTS).some((tag) => doc.querySelector(tag) !== null),
};
