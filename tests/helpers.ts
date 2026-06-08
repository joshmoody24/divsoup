import type { AchievementContext } from "../src/achievements";

export const contextFromHtml = (rawHtml: string): AchievementContext => ({
  doc: new DOMParser().parseFromString(rawHtml, "text/html"),
  rawHtml,
});
