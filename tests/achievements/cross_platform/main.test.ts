import { describe, expect, it } from "vitest";
import { rule } from "../../../src/achievements/cross_platform/main";
import { contextFromHtml } from "../../helpers";

export const testedAchievementId = rule.id;

describe(rule.id, () => {
  it("earns when vendor-prefixed CSS appears", () => {
    const html = `<html><head><style>.box { -webkit-border-radius: 10px; }</style></head><body></body></html>`;
    expect(rule.evaluate(contextFromHtml(html))).toBe(true);
  });

  it("does not earn with only standard CSS", () => {
    const html = `<html><head><style>.box { border-radius: 10px; }</style></head><body></body></html>`;
    expect(rule.evaluate(contextFromHtml(html))).toBe(false);
  });
});
