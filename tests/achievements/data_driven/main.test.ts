import { describe, expect, it } from "vitest";
import { rule } from "../../../src/achievements/data_driven/main";

export const testedAchievementId = rule.id;

describe(rule.id, () => {
  it("has required metadata", () => {
    expect(rule.title.length).toBeGreaterThan(0);
    expect(rule.group.length).toBeGreaterThan(0);
    expect(rule.description.length).toBeGreaterThan(0);
  });

  it("returns a boolean", () => {
    const doc = new DOMParser().parseFromString("<html></html>", "text/html");
    expect(typeof rule.evaluate({ doc, rawHtml: "<html></html>" })).toBe("boolean");
  });
});
