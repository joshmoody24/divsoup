import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "slot_machine.main",
  title: "Slot Machine",
  group: "slot_machine",
  description:
    "Page uses three <code>&lt;slot&gt;</code> elements in a row in a <code>&lt;template&gt;</code>",
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("slot_machine.main", context),
};
