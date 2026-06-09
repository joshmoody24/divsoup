import { describe, expect, it } from "vitest";
import { rule } from "../../../src/achievements/form_fanatic/main";
import { contextFromHtml } from "../../helpers";

export const testedAchievementId = rule.id;

describe(rule.id, () => {
  it("earns with five or more distinct form input types", () => {
    const html = `
      <html><body>
        <form>
          <input type="text" />
          <input type="email" />
          <input type="password" />
          <input type="number" />
          <input type="checkbox" />
          <textarea></textarea>
        </form>
      </body></html>
    `;

    expect(rule.evaluate(contextFromHtml(html))).toBe(true);
  });

  it("does not earn without forms or enough input variety", () => {
    const html = `<html><body><form><input type="text" /><input type="email" /></form></body></html>`;
    expect(rule.evaluate(contextFromHtml(html))).toBe(false);
  });
});
