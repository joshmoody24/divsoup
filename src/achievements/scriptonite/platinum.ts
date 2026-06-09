import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "scriptonite.platinum",
  title: "Always bet on text",
  group: "the_web_is_for_documents",
  description: "Page is entirely plaintext - no CSS, JavaScript, or HTML elements",
  hierarchy: "platinum",
  evaluate: ({ doc, rawHtml }) => {
    const hasAnyTags = rawHtml.includes("<") && rawHtml.includes(">");
    if (!hasAnyTags) return true;
    const html = doc.documentElement;
    if (!html) return false;
    const body = doc.body;
    const head = doc.head;
    if (!body || !head) return false;
    if (body.children.length !== 1 || body.firstElementChild?.tagName.toLowerCase() !== "pre")
      return false;
    const pre = body.firstElementChild;
    if (!pre) return false;
    const preAttrsOk = Array.from(pre.attributes).every((attr) => attr.name === "style");
    const headOk = Array.from(head.children).every(
      (child) => child.tagName.toLowerCase() === "meta",
    );
    return preAttrsOk && headOk && html.tagName.toLowerCase() === "html";
  },
};
