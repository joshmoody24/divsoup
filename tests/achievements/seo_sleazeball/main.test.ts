import { describe, expect, it } from "vitest";
import { rule } from "../../../src/achievements/seo_sleazeball/main";
import { contextFromHtml } from "../../helpers";

export const testedAchievementId = rule.id;

describe(rule.id, () => {
  it("earns only when OG, Twitter, and description meta tags all exist", () => {
    const html = `
      <html><head>
        <meta name="description" content="desc" />
        <meta property="og:title" content="og" />
        <meta name="twitter:card" content="summary" />
      </head><body></body></html>
    `;

    expect(rule.evaluate(contextFromHtml(html))).toBe(true);
  });

  it("does not earn when any required SEO meta type is missing", () => {
    const html = `<html><head><meta name="description" content="desc" /><meta property="og:title" content="og" /></head><body></body></html>`;
    expect(rule.evaluate(contextFromHtml(html))).toBe(false);
  });
});
