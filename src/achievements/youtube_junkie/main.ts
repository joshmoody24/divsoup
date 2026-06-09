import type { AchievementRule } from "../types";
import { isYoutubeUrl } from "../utils";

const requiredEmbeds = 3;

export const rule: AchievementRule = {
  id: "youtube_junkie.main",
  title: "YouTube Junkie",
  group: "youtube_junkie",
  description: `Page embeds <strong>${requiredEmbeds}</strong> or more <a href="https://youtube.com" target="_blank">YouTube</a> videos`,
  hierarchy: "standard",
  evaluate: ({ doc, rawHtml }) => {
    const iframeCount = doc.querySelectorAll(
      "iframe[src*='youtube.com'], iframe[src*='youtu.be']",
    ).length;
    const objectCount = doc.querySelectorAll(
      "object[data*='youtube.com'], object[data*='youtu.be']",
    ).length;
    const embedCount = doc.querySelectorAll(
      "embed[src*='youtube.com'], embed[src*='youtu.be']",
    ).length;
    const videoCount = Array.from(doc.querySelectorAll("video")).filter((video) =>
      Array.from(video.querySelectorAll("source")).some((source) => {
        const src = source.getAttribute("src") ?? "";
        return isYoutubeUrl(src);
      }),
    ).length;
    const oldEmbedCount = (
      rawHtml.match(
        /<param\s+name=["']movie["']\s+value=["'](?:[^"']*?youtu(?:\.be|be\.com)[^"']*?)["']/gi,
      ) ?? []
    ).length;
    return iframeCount + objectCount + embedCount + videoCount + oldEmbedCount >= requiredEmbeds;
  },
};
