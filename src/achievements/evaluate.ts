import type { AchievementContext, AchievementId } from "./types";

const ALL_HTML_ELEMENTS = [
  "a",
  "abbr",
  "acronym",
  "address",
  "area",
  "article",
  "aside",
  "audio",
  "b",
  "base",
  "bdi",
  "bdo",
  "big",
  "blockquote",
  "body",
  "br",
  "button",
  "canvas",
  "caption",
  "center",
  "cite",
  "code",
  "col",
  "colgroup",
  "data",
  "datalist",
  "dd",
  "del",
  "details",
  "dfn",
  "dialog",
  "dir",
  "div",
  "dl",
  "dt",
  "em",
  "embed",
  "fencedframe",
  "fieldset",
  "figcaption",
  "figure",
  "font",
  "footer",
  "form",
  "frame",
  "frameset",
  "h1",
  "head",
  "header",
  "hgroup",
  "hr",
  "html",
  "i",
  "iframe",
  "img",
  "input",
  "ins",
  "kbd",
  "label",
  "legend",
  "li",
  "link",
  "main",
  "map",
  "mark",
  "marquee",
  "menu",
  "meta",
  "meter",
  "nav",
  "nobr",
  "noembed",
  "noframes",
  "noscript",
  "object",
  "ol",
  "optgroup",
  "option",
  "output",
  "p",
  "param",
  "picture",
  "plaintext",
  "pre",
  "progress",
  "q",
  "rb",
  "rp",
  "rt",
  "rtc",
  "ruby",
  "s",
  "samp",
  "script",
  "search",
  "section",
  "select",
  "selectedcontent",
  "slot",
  "small",
  "source",
  "span",
  "strike",
  "strong",
  "style",
  "sub",
  "summary",
  "sup",
  "table",
  "tbody",
  "td",
  "template",
  "textarea",
  "tfoot",
  "th",
  "thead",
  "time",
  "title",
  "tr",
  "track",
  "tt",
  "u",
  "ul",
  "var",
  "video",
  "wbr",
  "xmp",
] as const;

const DEPRECATED_ELEMENTS = new Set([
  "acronym",
  "big",
  "center",
  "dir",
  "font",
  "frame",
  "frameset",
  "marquee",
  "nobr",
  "noembed",
  "noframes",
  "param",
  "plaintext",
  "rb",
  "rtc",
  "strike",
  "tt",
  "xmp",
]);

const VOID_ELEMENTS = [
  "area",
  "base",
  "br",
  "col",
  "embed",
  "hr",
  "img",
  "input",
  "link",
  "meta",
  "source",
  "track",
  "wbr",
] as const;
const BULLET_CHARS = [
  "•",
  "·",
  "●",
  "○",
  "◆",
  "◇",
  "■",
  "□",
  "▪",
  "▫",
  "▶",
  "►",
  "▸",
  "▹",
  "▼",
  "▽",
  "▾",
  "▿",
  "◘",
  "◙",
  "◦",
  "★",
  "☆",
  "✓",
  "✔",
  "✗",
  "✘",
  "⁃",
  "⁕",
  "⁎",
  "⁍",
  "⦿",
  "⦾",
  "⧫",
  "⧮",
] as const;
const COLOR_KEYWORDS: Record<string, string> = {
  white: "#ffffff",
  ivory: "#fffff0",
  snow: "#fffafa",
  whitesmoke: "#f5f5f5",
  seashell: "#fff5ee",
  ghostwhite: "#f8f8ff",
  azure: "#f0ffff",
  black: "#000000",
  darkslategray: "#2f4f4f",
  darkslategrey: "#2f4f4f",
  dimgray: "#696969",
  dimgrey: "#696969",
  slategray: "#708090",
  slategrey: "#708090",
};

export const evaluateRule = (id: AchievementId, context: AchievementContext): boolean => {
  const { doc, rawHtml } = context;

  switch (id) {
    case "anarchic_style_sheets.main":
      return doc.querySelectorAll("body style").length >= 3;
    case "ascii_art.main":
      return hasAsciiArtComment(rawHtml);
    case "backwards_compatibility.main":
      return /<!--\s*\[\s*if\s+IE\s*\].*?<!\[endif\]\s*-->/is.test(rawHtml);
    case "bigheaded.main":
      return doc.querySelectorAll("head *").length >= 25;
    case "bind_person_hater.main": {
      const imgs = Array.from(doc.querySelectorAll("img"));
      const missingAltCount = imgs.filter((img) => {
        const alt = img.getAttribute("alt");
        return alt === null || alt === "";
      }).length;
      const ariaPresent = Array.from(doc.querySelectorAll("*")).some((el) =>
        Array.from(el.attributes).some((attr) => attr.name.startsWith("aria-")),
      );
      const missingAlt = imgs.length > 0 && missingAltCount > imgs.length / 2;
      return missingAlt && !ariaPresent;
    }
    case "bob_ross.main":
      return doc.querySelector("canvas, picture") !== null;
    case "bullet_hell.main": {
      const htmlLists = doc.querySelectorAll("ul, ol").length;
      const bulletElements = Array.from(
        doc.querySelectorAll("p, div, span, h1, h2, h3, h4, h5, h6"),
      )
        .map((el) => (el.textContent ?? "").trim())
        .filter((text) => BULLET_CHARS.some((bullet) => text.startsWith(bullet)));

      const textWithBullets = Array.from(doc.querySelectorAll("*:not(ul):not(ol):not(li)"))
        .map((el) => el.textContent ?? "")
        .some((text) => {
          const bulletLines = text
            .split(/\r?\n/)
            .map((line) => line.trim())
            .filter((line) => BULLET_CHARS.some((bullet) => line.startsWith(bullet)));
          return bulletLines.length >= 2;
        });

      return (bulletElements.length >= 2 || textWithBullets) && htmlLists === 0;
    }
    case "class_warfare.main":
      return Array.from(doc.querySelectorAll("*[class]")).some(
        (el) => (el.getAttribute("class") ?? "").trim().split(/\s+/).filter(Boolean).length > 50,
      );
    case "classy.bronze":
      return getClassRatio(doc, rawHtml) > 0.1;
    case "classy.silver":
      return getClassRatio(doc, rawHtml) > 0.25;
    case "classy.gold":
      return getClassRatio(doc, rawHtml) > 0.333;
    case "classy.platinum":
      return getClassRatio(doc, rawHtml) > 0.5;
    case "data_driven.main":
      return (
        Array.from(doc.querySelectorAll("*")).filter((el) =>
          Array.from(el.attributes).some((attr) => attr.name.startsWith("data-")),
        ).length > 8
      );
    case "dictionary_enthusiast.main":
      return (
        doc.querySelector("dfn") !== null ||
        (doc.querySelector("dl dt") !== null && doc.querySelector("dl dd") !== null)
      );
    case "div_soup.bronze":
      return getDivRatio(doc) > 0.25;
    case "div_soup.silver":
      return getDivRatio(doc) > 0.5;
    case "div_soup.gold":
      return getDivRatio(doc) > 0.75;
    case "div_soup.platinum":
      return getDivRatio(doc) > 0.9;
    case "dynamic_content.main":
      return doc.querySelector("output") !== null;
    case "empty_calories.main":
      return (
        Array.from(doc.querySelectorAll("div, span")).filter(
          (el) => el.children.length === 0 && (el.textContent ?? "").trim() === "",
        ).length >= 10
      );
    case "flashbang.gold": {
      if (hasDarkModeSupport(doc, rawHtml)) return false;
      const bg = extractBackgroundColor(doc, rawHtml);
      return bg !== null && calculateBrightness(bg) > 0.85;
    }
    case "flashbang.platinum": {
      const lightInDark = hasLightInDarkMode(doc, rawHtml);
      const darkInLight = hasDarkInLightMode(doc, rawHtml);
      return lightInDark || darkInLight;
    }
    case "framework_phobia.main": {
      const frameworks = detectWebFrameworks(doc);
      return containsCustomElement(rawHtml) && frameworks.length === 0;
    }
    case "hyperlink_collector.bronze":
      return countUniqueExternalDomains(doc) >= 5;
    case "hyperlink_collector.silver":
      return countUniqueExternalDomains(doc) >= 10;
    case "hyperlink_collector.gold":
      return countUniqueExternalDomains(doc) >= 25;
    case "hyperlink_collector.platinum":
      return countUniqueExternalDomains(doc) >= 50;
    case "impa.main":
      return /\.attachShadow\s*\(|<template\s+[^>]*shadowroot\s*=\s*["'](?:open|closed)["'][^>]*>/i.test(
        rawHtml,
      );
    case "important_person.main":
      return (rawHtml.match(/!important/g) ?? []).length >= 10;
    case "locality_of_appearance.main":
      return attrContentLength(doc, "style") > attrContentLength(doc, "class");
    case "lorem_ipsum.main":
      return (doc.body?.textContent ?? "").toLowerCase().includes("lorem ipsum");
    case "master_of_elements.bronze":
      return countValidElementsUsed(doc) >= 17;
    case "master_of_elements.silver":
      return countValidElementsUsed(doc) >= 60;
    case "master_of_elements.gold":
      return countValidElementsUsed(doc) >= 118;
    case "master_of_elements.platinum":
      return missingHtmlElements(doc).size === 0;
    case "millionth_visitor.main":
      return doc.querySelector("blink, marquee") !== null;
    case "ok_boomer.main":
      return Array.from(DEPRECATED_ELEMENTS).some((tag) => doc.querySelector(tag) !== null);
    case "oops_all_frameworks.main": {
      const frameworks = detectWebFrameworks(doc);
      return ["React", "Vue", "Angular"].every((framework) => frameworks.includes(framework));
    }
    case "phd_purist.main":
      return Array.from(doc.querySelectorAll("math")).some(
        (math) =>
          math.children.length >= 5 ||
          math.querySelector("mfrac, msqrt, mroot, msubsup, munderover, mtable") !== null,
      );
    case "preemptive_strike.main":
      return Array.from(doc.querySelectorAll("link")).some((link) => {
        const rel = (link.getAttribute("rel") ?? "").toLowerCase();
        return (
          rel.includes("preload") || rel.includes("dns-prefetch") || rel.includes("preconnect")
        );
      });
    case "progressive.main":
      return doc.querySelector("progress") !== null && doc.querySelector("meter") !== null;
    case "quirky.main":
      return !/<!DOCTYPE html>/i.test(rawHtml);
    case "regressive_enhancement.main":
      return Array.from(doc.querySelectorAll("noscript")).some(
        (el) => (el.textContent ?? "").replace(/\s/g, "").length < 100,
      );
    case "scriptonite.silver":
      return doc.querySelector("script") === null && !hasOnAttribute(doc);
    case "scriptonite.gold":
      return (
        doc.querySelector("script") === null &&
        !hasOnAttribute(doc) &&
        !hasStyleAttribute(doc) &&
        doc.querySelector('style, link[rel="stylesheet"], img') === null
      );
    case "scriptonite.platinum": {
      const hasAnyTags = rawHtml.includes("<") && rawHtml.includes(">");
      if (!hasAnyTags) return true;
      const html = doc.documentElement;
      if (!html) return false;
      const body = doc.body;
      const head = doc.head;
      if (!body || !head) return false;
      if (body.children.length !== 1 || body.firstElementChild?.tagName.toLowerCase() !== "pre")
        return false;
      const pre = body.firstElementChild;
      if (!pre) return false;
      const preAttrsOk = Array.from(pre.attributes).every((attr) => attr.name === "style");
      const headOk = Array.from(head.children).every(
        (child) => child.tagName.toLowerCase() === "meta",
      );
      return preAttrsOk && headOk && html.tagName.toLowerCase() === "html";
    }
    case "self_love.main":
      return doc.querySelector('a[href="#"]') !== null;
    case "semantic_snob.gold":
      return ["header", "nav", "main", "article", "section", "aside", "footer"].every(
        (tag) => doc.querySelector(tag) !== null,
      );
    case "semantic_snob.platinum":
      return (
        ["header", "nav", "main", "article", "section", "aside", "footer"].every(
          (tag) => doc.querySelector(tag) !== null,
        ) && doc.querySelector("div, span") === null
      );
    case "slot_machine.main":
      return doc.querySelector("template slot + slot + slot") !== null;
    case "small_data.main":
      return (
        doc.querySelector(
          'script[type="application/ld+json"], [itemscope], [itemtype], [itemprop]',
        ) !== null
      );
    case "soap_box.main":
      return Array.from(rawHtml.matchAll(/<!--([\s\S]*?)-->/g)).some(
        (match) => match[1].trim().split(/\s+/).filter(Boolean).length > 100,
      );
    case "test_in_prod.main":
      return /console\.log\s*\(/.test(rawHtml);
    case "todo.bronze":
      return rawHtml.toUpperCase().includes("TODO");
    case "todo.silver":
      return rawHtml.toLowerCase().split("todo").length >= 3;
    case "todo.gold":
      return rawHtml.toLowerCase().split("todo").length >= 12;
    case "too_meta.main":
      return doc.querySelectorAll("head meta").length >= 8;
    case "tower_of_babel.main":
      return (
        new Set(
          Array.from(doc.querySelectorAll("*[lang]"))
            .map((el) => el.getAttribute("lang") ?? "")
            .filter(Boolean),
        ).size >= 2
      );
    case "tree_shenanigans.deep_puddle": {
      if (!doc.body) return false;
      return longestSingleChildChain(doc.body) >= 8;
    }
    case "tree_shenanigans.shallow_ocean": {
      if (!doc.body) return false;
      const depths = collectDepths(doc.body, 1);
      if (depths.length === 0) return false;
      return depths.reduce((sum, depth) => sum + depth, 0) / depths.length <= 3;
    }
    case "type_hints.natural_language_static_typing":
      return doc.querySelector('input[spellcheck="true"], textarea[spellcheck="true"]') !== null;
    case "type_hints.type_hints":
      return doc.querySelector("datalist") !== null;
    case "vintage.main":
      return doc.querySelector("table table") !== null;
    case "void_elements.open_minded": {
      const result = analyzeVoidElements(rawHtml);
      return result.total > 0 && result.withoutSlash === result.total;
    }
    case "void_elements.double_minded": {
      const result = analyzeVoidElements(rawHtml);
      return result.total >= 2 && result.withSlash > 0 && result.withoutSlash > 0;
    }
    case "void_elements.close_minded": {
      const result = analyzeVoidElements(rawHtml);
      return result.total > 0 && result.withSlash === result.total;
    }
    case "we_do_things_a_little_different.main":
      return Array.from(doc.querySelectorAll("span")).some(
        (span) => span.querySelector("div") !== null,
      );
    case "web_1_0_certified.main":
      return /<!DOCTYPE\s+HTML\s+PUBLIC\s+"-\/\/W3C\/\/DTD\s+HTML\s+3\.2(\s+Final)?\/\/EN"/i.test(
        rawHtml,
      );
    case "you_are_amazing_embed.main":
      return doc.querySelector("object, embed, iframe") !== null;
    case "youtube_junkie.main": {
      const iframeCount = doc.querySelectorAll(
        "iframe[src*='youtube.com'], iframe[src*='youtu.be']",
      ).length;
      const objectCount = doc.querySelectorAll(
        "object[data*='youtube.com'], object[data*='youtu.be']",
      ).length;
      const embedCount = doc.querySelectorAll(
        "embed[src*='youtube.com'], embed[src*='youtu.be']",
      ).length;
      const videoCount = Array.from(doc.querySelectorAll("video")).filter((video) =>
        Array.from(video.querySelectorAll("source")).some((source) => {
          const src = source.getAttribute("src") ?? "";
          return isYoutubeUrl(src);
        }),
      ).length;
      const oldEmbedCount = (
        rawHtml.match(
          /<param\s+name=["']movie["']\s+value=["'](?:[^"']*?youtu(?:\.be|be\.com)[^"']*?)["']/gi,
        ) ?? []
      ).length;
      return iframeCount + objectCount + embedCount + videoCount + oldEmbedCount >= 3;
    }
    case "zalgo.main":
      return /[^\p{M}][\p{M}]{3,}/u.test(rawHtml);
    default:
      return false;
  }
};

const getClassRatio = (doc: Document, rawHtml: string): number => {
  const classesSize = Array.from(doc.querySelectorAll("*[class]"))
    .map((el) => el.getAttribute("class") ?? "")
    .join(" ").length;
  if (classesSize === 0 || rawHtml.length === 0) return 0;
  return Number((classesSize / rawHtml.length).toFixed(2));
};

const getDivRatio = (doc: Document): number => {
  const divCount = doc.querySelectorAll("div").length;
  const elementCount = doc.querySelectorAll("*").length;
  if (elementCount === 0) return 0;
  return Number((divCount / elementCount).toFixed(2));
};

const countValidElementsUsed = (doc: Document): number => {
  const valid = new Set(ALL_HTML_ELEMENTS);
  const used = new Set(
    Array.from(doc.querySelectorAll("*"))
      .map((el) => el.tagName.toLowerCase())
      .filter((tag) => valid.has(tag as (typeof ALL_HTML_ELEMENTS)[number])),
  );
  return used.size;
};

const missingHtmlElements = (doc: Document): Set<string> => {
  const used = new Set(Array.from(doc.querySelectorAll("*")).map((el) => el.tagName.toLowerCase()));
  return new Set(ALL_HTML_ELEMENTS.filter((tag) => !used.has(tag)));
};

const attrContentLength = (doc: Document, attribute: string): number =>
  Array.from(doc.querySelectorAll(`*[${attribute}]`))
    .map((el) => el.getAttribute(attribute) ?? "")
    .join(" ").length;

const hasOnAttribute = (doc: Document): boolean =>
  Array.from(doc.querySelectorAll("*")).some((el) =>
    Array.from(el.attributes).some((attr) => attr.name.startsWith("on")),
  );

const hasStyleAttribute = (doc: Document): boolean =>
  Array.from(doc.querySelectorAll("*")).some((el) => el.hasAttribute("style"));

const countUniqueExternalDomains = (doc: Document): number => {
  const domains = new Set<string>();
  for (const link of Array.from(doc.querySelectorAll("a[href]"))) {
    const href = (link.getAttribute("href") ?? "").trim();
    if (/^(javascript|mailto|tel|data|vbscript):/i.test(href) || href.startsWith("#")) continue;
    if (!href.includes("://") && !href.startsWith("//")) continue;
    try {
      const url = new URL(href.startsWith("//") ? `https:${href}` : href);
      if (!["http:", "https:"].includes(url.protocol)) continue;
      if (url.hostname) domains.add(url.hostname);
    } catch {
      // ignore invalid URLs
    }
  }
  return domains.size;
};

const detectWebFrameworks = (doc: Document): string[] => {
  const frameworks: string[] = [];
  if (doc.querySelector("[data-reactroot], [data-reactid], script[src*='react']"))
    frameworks.push("React");
  if (doc.querySelector("[ng-app], [ng-controller], [ng-version], script[src*='angular']"))
    frameworks.push("Angular");
  if (doc.querySelector("[v-bind], [v-model], [v-for], [v-if], [data-v-]")) frameworks.push("Vue");
  if (doc.querySelector("[data-ember-view], .ember-application, script[src*='ember']"))
    frameworks.push("Ember");
  if (doc.querySelector("[data-svelte-component], [data-svelte-hydrate], script[src*='svelte']"))
    frameworks.push("Svelte");
  if (doc.querySelector("dom-module, script[src*='polymer']")) frameworks.push("Polymer");
  return frameworks;
};

const containsCustomElement = (rawHtml: string): boolean =>
  /<([A-Za-z0-9]+-[A-Za-z0-9]+)(\s+[^>]*)?>.*<\/\1>/s.test(rawHtml);

const isYoutubeUrl = (value: string): boolean => {
  const normalized = value.trim();
  if (!normalized) return false;
  try {
    const url = new URL(
      normalized.startsWith("//") ? `https:${normalized}` : normalized,
      "https://example.com",
    );
    const hostname = url.hostname.toLowerCase();
    return (
      hostname === "youtube.com" ||
      hostname.endsWith(".youtube.com") ||
      hostname === "youtu.be" ||
      hostname.endsWith(".youtu.be")
    );
  } catch {
    return false;
  }
};

const longestSingleChildChain = (element: Element): number => {
  const childElements = Array.from(element.children);
  if (childElements.length === 0) return 1;
  if (childElements.length === 1) return 1 + longestSingleChildChain(childElements[0]);
  return Math.max(0, ...childElements.map((child) => longestSingleChildChain(child)));
};

const collectDepths = (element: Element, currentDepth: number): number[] => {
  const depths: number[] = [];
  for (const child of Array.from(element.children)) {
    depths.push(currentDepth);
    depths.push(...collectDepths(child, currentDepth + 1));
  }
  return depths;
};

const analyzeVoidElements = (
  rawHtml: string,
): { withSlash: number; withoutSlash: number; total: number } => {
  let withSlash = 0;
  let withoutSlash = 0;

  for (const element of VOID_ELEMENTS) {
    const slashPattern = new RegExp(`<${element}[^>]*\\/>`, "gi");
    const withoutPattern = new RegExp(`<${element}[^>\\/]*>(?!.*<\\/${element}>)`, "gi");
    withSlash += (rawHtml.match(slashPattern) ?? []).length;
    withoutSlash += (rawHtml.match(withoutPattern) ?? []).length;
  }

  return { withSlash, withoutSlash, total: withSlash + withoutSlash };
};

const normalizeColor = (input: string): string | null => {
  const color = input.trim().toLowerCase();
  if (color.startsWith("#")) return color;
  if (COLOR_KEYWORDS[color]) return COLOR_KEYWORDS[color];

  const rgbMatch = color.match(/rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)/i);
  if (rgbMatch) {
    const [r, g, b] = rgbMatch
      .slice(1, 4)
      .map((value) => Math.max(0, Math.min(255, Number(value))));
    return `#${r.toString(16).padStart(2, "0")}${g.toString(16).padStart(2, "0")}${b.toString(16).padStart(2, "0")}`;
  }

  const rgbPercentMatch = color.match(/rgba?\(\s*(\d+)%\s*,\s*(\d+)%\s*,\s*(\d+)%/i);
  if (rgbPercentMatch) {
    const [r, g, b] = rgbPercentMatch
      .slice(1, 4)
      .map((value) => Math.max(0, Math.min(255, Math.round((Number(value) * 255) / 100))));
    return `#${r.toString(16).padStart(2, "0")}${g.toString(16).padStart(2, "0")}${b.toString(16).padStart(2, "0")}`;
  }

  return null;
};

const hexToRgb = (hex: string): [number, number, number] => {
  const normalized = hex.replace(/^#/, "");
  if (normalized.length === 3) {
    const [r, g, b] = normalized.split("");
    return [parseInt(`${r}${r}`, 16), parseInt(`${g}${g}`, 16), parseInt(`${b}${b}`, 16)];
  }
  if (normalized.length === 6) {
    return [
      parseInt(normalized.slice(0, 2), 16),
      parseInt(normalized.slice(2, 4), 16),
      parseInt(normalized.slice(4, 6), 16),
    ];
  }
  return [255, 255, 255];
};

const calculateBrightness = (color: string): number => {
  const normalized = normalizeColor(color);
  if (!normalized) return 1;
  const [r, g, b] = hexToRgb(normalized);
  return (0.299 * r + 0.587 * g + 0.114 * b) / 255;
};

const extractFromMediaQuery = (css: string, scheme: "dark" | "light"): string | null => {
  const regex = new RegExp(
    `@media\\s*\\(\\s*prefers-color-scheme\\s*:\\s*${scheme}\\s*\\)[^{]*{[^}]*(background(-color)?:\\s*([^;]*))`,
    "i",
  );
  const match = css.match(regex);
  if (!match) return null;
  const color = match[3] ?? "";
  return normalizeColor(color);
};

const extractFromInlineStyle = (style: string): string | null => {
  const match = style.match(/background(-color)?:\s*([^;]*)/i);
  if (!match) return null;
  return normalizeColor(match[2]);
};

const extractGeneralBackground = (
  htmlStyle: string,
  bodyStyle: string,
  styleContent: string,
): string | null => {
  const htmlBg = extractFromInlineStyle(htmlStyle);
  const bodyBg = extractFromInlineStyle(bodyStyle);

  const bodyCss = styleContent.match(/body\s*{[^}]*(background(-color)?:\s*([^;]*))/i);
  const htmlCss = styleContent.match(/html\s*{[^}]*(background(-color)?:\s*([^;]*))/i);
  const mainCss = styleContent.match(/main\s*{[^}]*(background(-color)?:\s*([^;]*))/i);

  const bodyCssBg = bodyCss ? normalizeColor(bodyCss[3]) : null;
  const htmlCssBg = htmlCss ? normalizeColor(htmlCss[3]) : null;
  const mainCssBg = mainCss ? normalizeColor(mainCss[3]) : null;

  return mainCssBg ?? bodyBg ?? htmlBg ?? bodyCssBg ?? htmlCssBg;
};

const hasMeaningfulColorSchemeQuery = (doc: Document, scheme: "dark" | "light"): boolean => {
  const styleBlocks = Array.from(doc.querySelectorAll("head style")).map(
    (style) => style.textContent ?? "",
  );
  const pattern = new RegExp(
    `@media\\s*\\(\\s*prefers-color-scheme\\s*:\\s*${scheme}\\s*\\)\\s*\\{[^}]*(html|body|main|\\.container|#container|#root|#app|\\.app|#main|\\.main|\\.content|#content)[^}]*\\}`,
    "i",
  );
  return styleBlocks.some((style) => pattern.test(style));
};

const extractBackgroundColor = (
  doc: Document,
  rawHtml: string,
  colorScheme?: "dark" | "light",
): string | null => {
  const styleContent = Array.from(doc.querySelectorAll("style"))
    .map((style) => style.textContent ?? "")
    .join(" ");
  const htmlStyle = doc.documentElement.getAttribute("style") ?? "";
  const bodyStyle = doc.body?.getAttribute("style") ?? "";
  const allCss = `${styleContent} ${htmlStyle} ${bodyStyle}`;

  const mediaColor = colorScheme ? extractFromMediaQuery(allCss, colorScheme) : null;
  if (mediaColor) return mediaColor;
  return (
    extractGeneralBackground(htmlStyle, bodyStyle, styleContent) ?? normalizeColor(rawHtml) ?? null
  );
};

const hasDarkModeSupport = (doc: Document, rawHtml: string): boolean => {
  if (!hasMeaningfulColorSchemeQuery(doc, "dark")) return false;
  const darkBg = extractBackgroundColor(doc, rawHtml, "dark");
  return darkBg !== null && calculateBrightness(darkBg) < 0.3;
};

const hasLightInDarkMode = (doc: Document, rawHtml: string): boolean => {
  if (!hasMeaningfulColorSchemeQuery(doc, "dark")) return false;
  const darkBg = extractBackgroundColor(doc, rawHtml, "dark");
  return darkBg !== null && calculateBrightness(darkBg) > 0.7;
};

const hasDarkInLightMode = (doc: Document, rawHtml: string): boolean => {
  if (!hasMeaningfulColorSchemeQuery(doc, "light")) return false;
  const lightBg = extractBackgroundColor(doc, rawHtml, "light");
  return lightBg !== null && calculateBrightness(lightBg) < 0.3;
};

const hasAsciiArtComment = (rawHtml: string): boolean => {
  const comments = Array.from(rawHtml.matchAll(/<!--([\s\S]*?)-->/g)).map((match) => match[1]);
  const asciiPatterns = [
    /\(\s*[oO0\-_^\\\/]\s*[_.,-]\s*[oO0\-_^\\\/]\s*\)/,
    /[<>]\s*[\^v\-_]\s*[<>]/,
    /\+[-_=]+\+/,
    /\|[^|]{2,}\|/,
    /\/[\\/]/,
    /[_~\-=]{3,}/,
    /[|:]{2,}/,
    /[\/\\]{2,}/,
    /\\\\_\/\\\\/,
  ];
  const asciiChars = [
    "+",
    "-",
    "|",
    "/",
    "\\",
    "*",
    "=",
    ">",
    "<",
    "^",
    "(",
    ")",
    "[",
    "]",
    "{",
    "}",
    "_",
    ".",
    ":",
    ";",
    "'",
    "`",
    "~",
    "#",
    "@",
  ];

  for (const comment of comments) {
    const lines = comment
      .split("\n")
      .map((line) => line.trim())
      .filter(Boolean);
    if (isLikelyCodeComment(comment)) continue;
    if (lines.length < 5) continue;

    const text = lines.join(" ");
    if (asciiPatterns.some((pattern) => pattern.test(text))) return true;

    const chars = Array.from(text);
    const specialCount = chars.filter((char) => asciiChars.includes(char)).length;
    const density = text.length > 0 ? specialCount / text.length : 0;
    const uniqueSpecial = asciiChars.filter((char) => text.includes(char)).length;
    if (density > 0.05 && uniqueSpecial >= 3) return true;
  }

  return false;
};

const isLikelyCodeComment = (comment: string): boolean => {
  const trimmed = comment.trim();
  if (!trimmed) return false;

  const definitiveMarkers = [
    "[if",
    "function",
    "var ",
    "class=",
    "<script",
    "</script>",
    "<![endif]",
  ];
  if (definitiveMarkers.some((marker) => trimmed.includes(marker))) return true;

  const lines = trimmed
    .split("\n")
    .map((line) => line.trim())
    .filter(Boolean);
  if (lines.length >= 3) {
    const symbols = ["/", "\\", "|", "-", "_", "+", "=", ">", "<", "^", "(", ")"];
    const artLike = lines.filter((line) => {
      const content = line.replace(/ /g, "");
      if (!content.length) return false;
      const symbolCount = Array.from(content).filter((char) => symbols.includes(char)).length;
      return symbolCount / content.length > 0.3;
    }).length;
    return artLike / lines.length < 0.33;
  }

  const noWhitespace = trimmed.replace(/\s/g, "");
  if (!noWhitespace.length) return false;
  const alphaNumCount = noWhitespace.replace(/[^a-zA-Z0-9]/g, "").length;
  return alphaNumCount / noWhitespace.length > 0.7;
};
