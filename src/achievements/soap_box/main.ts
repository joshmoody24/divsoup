import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "soap_box.main",
  title: "Soap Box",
  group: "soap_box",
  description: "Page contains an HTML <code>&lt;!-- comment --&gt;</code> with more than <strong>100</strong> words",
  hierarchy: "standard",
  evaluate: () => false,
};
