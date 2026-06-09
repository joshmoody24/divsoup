import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "lorem_ipsum.main",
  title: "Textus Vicarious",
  group: "lorem_ipsum",
  description: '<i>Pagina locutionem "lorem ipsum" continet</i>',
  hierarchy: "standard",
  evaluate: ({ doc }) => (doc.body?.textContent ?? "").toLowerCase().includes("lorem ipsum"),
};
