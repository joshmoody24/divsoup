import { describe, expect, it } from "vitest";
import { analyzeHtml, sortAchievements, titleizeGroup } from "../src/analyze";
import type { AchievementRule } from "../src/achievements";

describe("analyzeHtml", () => {
  it("returns earned achievements, misses, and sorted groups for pasted HTML", () => {
    const html = `
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <title>Analyzer Test</title>
          <meta name="description" content="desc">
          <meta property="og:title" content="og">
          <meta name="twitter:card" content="summary">
          <link rel="preconnect" href="https://example.com">
        </head>
        <body>
          <header><h1>One</h1><h1>Two</h1></header>
          <nav><a href="#content">Skip</a></nav>
          <main id="content">
            <article><section><p>Using HTMX here.</p></section></article>
          </main>
          <aside></aside>
          <footer></footer>
        </body>
      </html>
    `;

    const result = analyzeHtml(html);
    const earnedIds = result.earned.map((achievement) => achievement.id);

    expect(earnedIds).toContain("seo_sleazeball.main");
    expect(earnedIds).toContain("hydra.main");
    expect(earnedIds).toContain("htmx.main");
    expect(result.missed.length + result.earned.length).toBe(result.totalAchievements);
    expect(result.groups.map((group) => group.group)).toContain("seo_sleazeball");
  });

  it("handles empty input without throwing", () => {
    const result = analyzeHtml("");
    expect(result.earnedAchievements).toBeGreaterThanOrEqual(0);
    expect(result.totalAchievements).toBeGreaterThan(0);
  });
});

describe("titleizeGroup", () => {
  it("formats achievement group identifiers", () => {
    expect(titleizeGroup("seo_sleazeball")).toBe("Seo Sleazeball");
  });
});

describe("sortAchievements", () => {
  it("orders achievements from least prestigious to most prestigious within a group", () => {
    const achievement = (
      hierarchy: AchievementRule["hierarchy"],
      title: string,
    ): AchievementRule => ({
      id: "todo.bronze",
      title,
      group: "test_group",
      description: "",
      hierarchy,
      evaluate: () => true,
    });

    expect(
      sortAchievements([
        achievement("platinum", "Platinum"),
        achievement("bronze", "Bronze"),
        achievement("gold", "Gold"),
        achievement("silver", "Silver"),
      ]).map((sortedAchievement) => sortedAchievement.hierarchy),
    ).toEqual(["bronze", "silver", "gold", "platinum"]);
  });
});
