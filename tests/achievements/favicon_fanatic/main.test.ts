import { describe, expect, it } from "vitest";
import { rule } from "../../../src/achievements/favicon_fanatic/main";
import { contextFromHtml } from "../../helpers";

export const testedAchievementId = rule.id;

describe(rule.id, () => {
  it("earns when head has more than three rel=icon links", () => {
    const html = `
      <html><head>
        <link rel="icon" href="/1.ico" />
        <link rel="icon" href="/2.ico" />
        <link rel="icon" href="/3.ico" />
        <link rel="icon" href="/4.ico" />
      </head><body></body></html>
    `;

    expect(rule.evaluate(contextFromHtml(html))).toBe(true);
  });

  it("does not earn with three or fewer rel=icon links", () => {
    const html = `<html><head><link rel="icon" href="/1.ico" /><link rel="icon" href="/2.ico" /><link rel="icon" href="/3.ico" /></head><body></body></html>`;
    expect(rule.evaluate(contextFromHtml(html))).toBe(false);
  });
});
