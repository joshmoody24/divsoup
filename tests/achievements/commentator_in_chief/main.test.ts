import { describe, expect, it } from "vitest";
import { rule } from "../../../src/achievements/commentator_in_chief/main";
import { contextFromHtml } from "../../helpers";

export const testedAchievementId = rule.id;

describe(rule.id, () => {
  it("earns with more than ten HTML comments", () => {
    const manyComments = Array.from({ length: 11 }, (_, i) => `<!-- c${i} -->`).join("\n");
    const html = `<html><head>${manyComments}</head><body></body></html>`;
    expect(rule.evaluate(contextFromHtml(html))).toBe(true);
  });

  it("does not earn with ten or fewer comments", () => {
    const someComments = Array.from({ length: 10 }, (_, i) => `<!-- c${i} -->`).join("\n");
    const html = `<html><head>${someComments}</head><body></body></html>`;
    expect(rule.evaluate(contextFromHtml(html))).toBe(false);
  });
});
