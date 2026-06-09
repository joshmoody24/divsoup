import type { AchievementRule } from "../types";

const VENDOR_PREFIX_REGEX = /-webkit-|-moz-|-o-|-ms-/;

export const rule: AchievementRule = {
  id: "cross_platform.main",
  title: "Fragmented Ecosystem",
  group: "cross_platform",
  description:
    "Page contains browser-specific CSS, e.g., <code>-webkit-</code>, <code>-moz-</code>, <code>-o-</code>, <code>-ms-</code>",
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    const inlineCss = Array.from(doc.querySelectorAll("style"))
      .map((el) => el.textContent ?? "")
      .join(" ");

    const attrCss = Array.from(doc.querySelectorAll("[style]"))
      .map((el) => el.getAttribute("style") ?? "")
      .join(" ");

    return VENDOR_PREFIX_REGEX.test(`${inlineCss} ${attrCss}`);
  },
};
