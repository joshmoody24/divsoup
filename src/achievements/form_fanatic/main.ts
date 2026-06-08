import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "form_fanatic.main",
  title: "Form Fanatic",
  group: "form_fanatic",
  description: "Page has a <code>&lt;form&gt;</code> containing <strong>#{@required_input_types}</strong> or more different input types",
  hierarchy: "standard",
  evaluate: () => false,
};
