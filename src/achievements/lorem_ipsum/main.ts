import type { AchievementRule } from "../types";
import { evaluateRule } from "../evaluate";

export const rule: AchievementRule = {
  id: "lorem_ipsum.main",
  title: "Textus Vicarious",
  group: "lorem_ipsum",
  description: '<i>Pagina locutionem "lorem ipsum" continet</i>',
  hierarchy: "standard",
  evaluate: (context) => evaluateRule("lorem_ipsum.main", context),
};
