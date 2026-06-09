import type { AchievementRule } from "../types";
import { BULLET_CHARS } from "../utils";

export const rule: AchievementRule = {
  id: "bullet_hell.main",
  title: "Bullet Hell",
  group: "bullet_hell",
  description:
    "Page uses unicode bullet points (• ◆ ★) to create a list instead of using <code>&lt;ul&gt;</code>",
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    const htmlLists = doc.querySelectorAll("ul, ol").length;
    const bulletElements = Array.from(doc.querySelectorAll("p, div, span, h1, h2, h3, h4, h5, h6"))
      .map((el) => (el.textContent ?? "").trim())
      .filter((text) => BULLET_CHARS.some((bullet) => text.startsWith(bullet)));

    const textWithBullets = Array.from(doc.querySelectorAll("*:not(ul):not(ol):not(li)"))
      .map((el) => el.textContent ?? "")
      .some((text) => {
        const bulletLines = text
          .split(/\r?\n/)
          .map((line) => line.trim())
          .filter((line) => BULLET_CHARS.some((bullet) => line.startsWith(bullet)));
        return bulletLines.length >= 2;
      });

    return (bulletElements.length >= 2 || textWithBullets) && htmlLists === 0;
  },
};
