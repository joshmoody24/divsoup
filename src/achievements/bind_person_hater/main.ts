import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "bind_person_hater.main",
  title: "Blind Person Hater",
  group: "blind_person_hater",
  description:
    "Majority of images lack <code>alt</code> attributes and/or no ARIA attributes appear on the page",
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    const imgs = Array.from(doc.querySelectorAll("img"));
    const missingAltCount = imgs.filter((img) => {
      const alt = img.getAttribute("alt");
      return alt === null || alt === "";
    }).length;
    const ariaPresent = Array.from(doc.querySelectorAll("*")).some((el) =>
      Array.from(el.attributes).some((attr) => attr.name.startsWith("aria-")),
    );
    const missingAlt = imgs.length > 0 && missingAltCount > imgs.length / 2;
    return missingAlt && !ariaPresent;
  },
};
