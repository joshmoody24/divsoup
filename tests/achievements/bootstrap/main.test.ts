import { describe, expect, it } from "vitest";
import { rule } from "../../../src/achievements/bootstrap/main";
import { contextFromHtml } from "../../helpers";

export const testedAchievementId = rule.id;

describe(rule.id, () => {
  it("earns when bootstrap CSS is referenced", () => {
    const html = `<html><head><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"></head><body></body></html>`;
    expect(rule.evaluate(contextFromHtml(html))).toBe(true);
  });

  it("does not earn without bootstrap references", () => {
    const html = `<html><head><link rel="stylesheet" href="styles.css"></head><body><script src="main.js"></script></body></html>`;
    expect(rule.evaluate(contextFromHtml(html))).toBe(false);
  });
});
