import type { AchievementRule } from "../types";
import { ALL_HTML_ELEMENTS, missingHtmlElements } from "../utils";

const totalElements = ALL_HTML_ELEMENTS.length;

export const rule: AchievementRule = {
  id: "master_of_elements.platinum",
  title: `Master of All ${totalElements} Elements`,
  group: "master_of_elements",
  description: "Page uses <strong>every HTML element</strong>, even the deprecated ones",
  hierarchy: "platinum",
  evaluate: ({ doc }) => missingHtmlElements(doc).size === 0,
};
