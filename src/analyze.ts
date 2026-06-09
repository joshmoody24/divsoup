import { rules } from "./achievements";
import type { AchievementHierarchy, AchievementRule } from "./achievements";

export interface HtmlParser {
  parseFromString(source: string, mimeType: DOMParserSupportedType): Document;
}

export interface AchievementGroupResult {
  group: string;
  title: string;
  earned: AchievementRule[];
  score: number;
}

export interface AnalysisResult {
  rawHtml: string;
  document: Document;
  earned: AchievementRule[];
  missed: AchievementRule[];
  groups: AchievementGroupResult[];
  totalAchievements: number;
  earnedAchievements: number;
}

const hierarchyRank: Record<AchievementHierarchy, number> = {
  standard: 0,
  bronze: 1,
  silver: 2,
  gold: 3,
  platinum: 4,
};

export const parseHtml = (rawHtml: string, parser: HtmlParser = new DOMParser()): Document =>
  parser.parseFromString(rawHtml, "text/html");

export const analyzeHtml = (rawHtml: string, parser?: HtmlParser): AnalysisResult => {
  const document = parseHtml(rawHtml, parser);
  const context = { doc: document, rawHtml };

  const earned = rules.filter((rule) => rule.evaluate(context));
  const earnedIds = new Set(earned.map((rule) => rule.id));
  const missed = rules.filter((rule) => !earnedIds.has(rule.id));

  return {
    rawHtml,
    document,
    earned: sortAchievements(earned),
    missed: sortAchievements(missed),
    groups: groupEarnedAchievements(earned),
    totalAchievements: rules.length,
    earnedAchievements: earned.length,
  };
};

export const sortAchievements = (achievements: AchievementRule[]): AchievementRule[] =>
  [...achievements].sort((left, right) => {
    const hierarchyDelta = hierarchyRank[left.hierarchy] - hierarchyRank[right.hierarchy];
    if (hierarchyDelta !== 0) return hierarchyDelta;

    const groupDelta = left.group.localeCompare(right.group);
    if (groupDelta !== 0) return groupDelta;

    return left.title.localeCompare(right.title);
  });

const groupEarnedAchievements = (achievements: AchievementRule[]): AchievementGroupResult[] => {
  const groups = new Map<string, AchievementRule[]>();

  for (const achievement of achievements) {
    const existing = groups.get(achievement.group) ?? [];
    groups.set(achievement.group, [...existing, achievement]);
  }

  return Array.from(groups.entries())
    .map(([group, groupAchievements]) => ({
      group,
      title: titleizeGroup(group),
      earned: sortAchievements(groupAchievements),
      score: groupAchievements.reduce(
        (total, achievement) => total + hierarchyRank[achievement.hierarchy],
        0,
      ),
    }))
    .sort((left, right) => {
      const scoreDelta = right.score - left.score;
      if (scoreDelta !== 0) return scoreDelta;

      const countDelta = right.earned.length - left.earned.length;
      if (countDelta !== 0) return countDelta;

      return left.title.localeCompare(right.title);
    });
};

export const titleizeGroup = (group: string): string =>
  group
    .split("_")
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(" ");
