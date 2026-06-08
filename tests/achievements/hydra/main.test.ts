import { describe, expect, it } from "vitest";
import { rule } from "../../../src/achievements/hydra/main";
import { contextFromHtml } from "../../helpers";

export const testedAchievementId = rule.id;

describe(rule.id, () => {
  it("earns when there are multiple h1 elements", () => {
    const html = `<html><body><h1>One</h1><h1>Two</h1></body></html>`;
    expect(rule.evaluate(contextFromHtml(html))).toBe(true);
  });

  it("does not earn with fewer than two h1 elements", () => {
    const html = `<html><body><h1>One</h1></body></html>`;
    expect(rule.evaluate(contextFromHtml(html))).toBe(false);
  });
});
