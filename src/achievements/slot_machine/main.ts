import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "slot_machine.main",
  title: "Slot Machine",
  group: "slot_machine",
  description:
    "Page uses three <code>&lt;slot&gt;</code> elements in a row in a <code>&lt;template&gt;</code>",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector("template slot + slot + slot") !== null,
};
