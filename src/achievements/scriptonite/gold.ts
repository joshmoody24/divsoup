import type { AchievementRule } from "../types";
import { hasOnAttribute, hasStyleAttribute } from "../utils";

export const rule: AchievementRule = {
  id: "scriptonite.gold",
  title: "i use lynx btw",
  group: "the_web_is_for_documents",
  description: "No JavaScript, CSS, or images appear in the page",
  hierarchy: "gold",
  evaluate: ({ doc }) =>
    doc.querySelector("script") === null &&
    !hasOnAttribute(doc) &&
    !hasStyleAttribute(doc) &&
    doc.querySelector('style, link[rel="stylesheet"], img') === null,
};
