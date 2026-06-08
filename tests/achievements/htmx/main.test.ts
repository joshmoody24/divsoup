import { describe, expect, it } from "vitest";
import { rule } from "../../../src/achievements/htmx/main";
import { contextFromHtml } from "../../helpers";

export const testedAchievementId = rule.id;

describe(rule.id, () => {
  it("earns when htmx appears in page content", () => {
    const html = `<html><body><p>Using HTMX for dynamic updates</p></body></html>`;
    expect(rule.evaluate(contextFromHtml(html))).toBe(true);
  });

  it("does not earn when htmx is absent", () => {
    const html = `<html><body><p>Using plain JavaScript</p></body></html>`;
    expect(rule.evaluate(contextFromHtml(html))).toBe(false);
  });
});
