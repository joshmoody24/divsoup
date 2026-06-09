import type { AchievementId, AchievementRule } from "./types";

export interface AchievementRegistry {
  readonly rules: readonly AchievementRule[];
  readonly rulesById: ReadonlyMap<AchievementId, AchievementRule>;
  register: (rule: AchievementRule) => void;
}

export const createAchievementRegistry = (): AchievementRegistry => {
  const registeredRules: AchievementRule[] = [];
  const registeredRulesById = new Map<AchievementId, AchievementRule>();

  return {
    get rules() {
      return [...registeredRules];
    },
    get rulesById() {
      return new Map(registeredRulesById);
    },
    register: (rule) => {
      const existingRule = registeredRulesById.get(rule.id);

      if (existingRule !== undefined) {
        throw new Error(`Duplicate achievement ID registered: ${rule.id}`);
      }

      registeredRules.push(rule);
      registeredRulesById.set(rule.id, rule);
    },
  };
};
