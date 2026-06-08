export type AchievementHierarchy = "standard" | "bronze" | "silver" | "gold" | "platinum";

export interface AchievementContext {
  doc: Document;
  rawHtml: string;
}

export interface AchievementRule {
  id: AchievementId;
  title: string;
  group: string;
  description: string;
  hierarchy: AchievementHierarchy;
  evaluate: (context: AchievementContext) => boolean;
}

export const achievementIds = [
  "anarchic_style_sheets.main",
  "ascii_art.main",
  "backwards_compatibility.main",
  "bigheaded.main",
  "bind_person_hater.main",
  "bob_ross.main",
  "bootstrap.main",
  "bullet_hell.main",
  "class_warfare.main",
  "classy.bronze",
  "classy.gold",
  "classy.platinum",
  "classy.silver",
  "commentator_in_chief.main",
  "cross_platform.main",
  "data_driven.main",
  "dictionary_enthusiast.main",
  "div_soup.bronze",
  "div_soup.gold",
  "div_soup.platinum",
  "div_soup.silver",
  "dynamic_content.main",
  "empty_calories.main",
  "favicon_fanatic.main",
  "flashbang.gold",
  "flashbang.platinum",
  "form_fanatic.main",
  "framework_phobia.main",
  "htmx.main",
  "hydra.main",
  "hyperlink_collector.bronze",
  "hyperlink_collector.gold",
  "hyperlink_collector.platinum",
  "hyperlink_collector.silver",
  "impa.main",
  "important_person.main",
  "locality_of_appearance.main",
  "lorem_ipsum.main",
  "master_of_elements.bronze",
  "master_of_elements.gold",
  "master_of_elements.platinum",
  "master_of_elements.silver",
  "millionth_visitor.main",
  "ok_boomer.main",
  "oops_all_frameworks.main",
  "phd_purist.main",
  "preemptive_strike.main",
  "progressive.main",
  "quirky.main",
  "regressive_enhancement.main",
  "scriptonite.gold",
  "scriptonite.platinum",
  "scriptonite.silver",
  "self_love.main",
  "semantic_snob.gold",
  "semantic_snob.platinum",
  "seo_sleazeball.main",
  "slot_machine.main",
  "small_data.main",
  "soap_box.main",
  "test_in_prod.main",
  "todo.bronze",
  "todo.gold",
  "todo.silver",
  "too_meta.main",
  "tower_of_babel.main",
  "tree_shenanigans.deep_puddle",
  "tree_shenanigans.shallow_ocean",
  "type_hints.natural_language_static_typing",
  "type_hints.type_hints",
  "vintage.main",
  "void_elements.close_minded",
  "void_elements.double_minded",
  "void_elements.open_minded",
  "we_do_things_a_little_different.main",
  "web_1_0_certified.main",
  "you_are_amazing_embed.main",
  "youtube_junkie.main",
  "zalgo.main",
] as const;

export type AchievementId = (typeof achievementIds)[number];
