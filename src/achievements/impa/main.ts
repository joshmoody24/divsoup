import type { AchievementRule } from "../types";

export const rule: AchievementRule = {
  id: "impa.main",
  title: "Impa",
  group: "impa",
  description: "Page uses the Shadow DOM",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) =>
    /\.attachShadow\s*\(|<template\s+[^>]*shadowroot\s*=\s*["'](?:open|closed)["'][^>]*>/i.test(
      rawHtml,
    ),
};
