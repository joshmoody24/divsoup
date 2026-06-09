import { describe, expect, it } from "vitest";
import { rule } from "../../src/achievements/div_soup/bronze";
import { createAchievementRegistry } from "../../src/achievements/registry";

describe("achievement registry", () => {
  it("throws when two achievements register the same ID", () => {
    const registry = createAchievementRegistry();

    registry.register(rule);

    expect(() => registry.register(rule)).toThrow(
      `Duplicate achievement ID registered: ${rule.id}`,
    );
  });
});
