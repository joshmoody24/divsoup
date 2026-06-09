import type { AchievementRule } from "../types";

const REQUIRED_INPUT_TYPES = 5;

export const rule: AchievementRule = {
  id: "form_fanatic.main",
  title: "Form Fanatic",
  group: "form_fanatic",
  description:
    "Page has a <code>&lt;form&gt;</code> containing <strong>5</strong> or more different input types",
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    const forms = Array.from(doc.querySelectorAll("form"));
    if (forms.length === 0) {
      return false;
    }

    const uniqueInputTypes = new Set<string>();

    for (const form of forms) {
      for (const input of form.querySelectorAll("input")) {
        uniqueInputTypes.add((input.getAttribute("type") ?? "text").toLowerCase());
      }

      if (form.querySelector("textarea")) {
        uniqueInputTypes.add("textarea");
      }

      if (form.querySelector("select")) {
        uniqueInputTypes.add("select");
      }
    }

    return uniqueInputTypes.size >= REQUIRED_INPUT_TYPES;
  },
};
