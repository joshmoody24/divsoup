export const ALL_HTML_ELEMENTS = [
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
];

export const DEPRECATED_ELEMENTS = new Set([
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

export const VOID_ELEMENTS = [
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
];
export const BULLET_CHARS = [
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
];
export const COLOR_KEYWORDS: Record<string, string> = {
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
export const getClassRatio = (doc: Document, rawHtml: string): number => {
  const classesSize = Array.from(doc.querySelectorAll("*[class]"))
    .map((el) => el.getAttribute("class") ?? "")
    .join(" ").length;
  if (classesSize === 0 || rawHtml.length === 0) return 0;
  return Number((classesSize / rawHtml.length).toFixed(2));
};

export const getDivRatio = (doc: Document): number => {
  const divCount = doc.querySelectorAll("div").length;
  const elementCount = doc.querySelectorAll("*").length;
  if (elementCount === 0) return 0;
  return Number((divCount / elementCount).toFixed(2));
};

export const countValidElementsUsed = (doc: Document): number => {
  const valid: ReadonlySet<string> = new Set(ALL_HTML_ELEMENTS);
  const used = new Set(
    Array.from(doc.querySelectorAll("*"))
      .map((el) => el.tagName.toLowerCase())
      .filter((tag) => valid.has(tag)),
  );
  return used.size;
};

export const missingHtmlElements = (doc: Document): Set<string> => {
  const used = new Set(Array.from(doc.querySelectorAll("*")).map((el) => el.tagName.toLowerCase()));
  return new Set(ALL_HTML_ELEMENTS.filter((tag) => !used.has(tag)));
};

export const attrContentLength = (doc: Document, attribute: string): number =>
  Array.from(doc.querySelectorAll(`*[${attribute}]`))
    .map((el) => el.getAttribute(attribute) ?? "")
    .join(" ").length;

export const hasOnAttribute = (doc: Document): boolean =>
  Array.from(doc.querySelectorAll("*")).some((el) =>
    Array.from(el.attributes).some((attr) => attr.name.startsWith("on")),
  );

export const hasStyleAttribute = (doc: Document): boolean =>
  Array.from(doc.querySelectorAll("*")).some((el) => el.hasAttribute("style"));

export const countUniqueExternalDomains = (doc: Document): number => {
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

export const detectWebFrameworks = (doc: Document): string[] => {
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

export const containsCustomElement = (rawHtml: string): boolean =>
  /<([A-Za-z0-9]+-[A-Za-z0-9]+)(\s+[^>]*)?>.*<\/\1>/s.test(rawHtml);

export const isYoutubeUrl = (value: string): boolean => {
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

export const longestSingleChildChain = (element: Element): number => {
  const childElements = Array.from(element.children);
  if (childElements.length === 0) return 1;
  if (childElements.length === 1) return 1 + longestSingleChildChain(childElements[0]);
  return Math.max(0, ...childElements.map((child) => longestSingleChildChain(child)));
};

export const collectDepths = (element: Element, currentDepth: number): number[] => {
  const depths: number[] = [];
  for (const child of Array.from(element.children)) {
    depths.push(currentDepth);
    depths.push(...collectDepths(child, currentDepth + 1));
  }
  return depths;
};

export const analyzeVoidElements = (
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

export const normalizeColor = (input: string): string | null => {
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

export const hexToRgb = (hex: string): [number, number, number] => {
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

export const calculateBrightness = (color: string): number => {
  const normalized = normalizeColor(color);
  if (!normalized) return 1;
  const [r, g, b] = hexToRgb(normalized);
  return (0.299 * r + 0.587 * g + 0.114 * b) / 255;
};

export const extractFromMediaQuery = (css: string, scheme: "dark" | "light"): string | null => {
  const regex = new RegExp(
    `@media\\s*\\(\\s*prefers-color-scheme\\s*:\\s*${scheme}\\s*\\)[^{]*{[^}]*(background(-color)?:\\s*([^;]*))`,
    "i",
  );
  const match = css.match(regex);
  if (!match) return null;
  const color = match[3] ?? "";
  return normalizeColor(color);
};

export const extractFromInlineStyle = (style: string): string | null => {
  const match = style.match(/background(-color)?:\s*([^;]*)/i);
  if (!match) return null;
  return normalizeColor(match[2]);
};

export const extractGeneralBackground = (
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

export const hasMeaningfulColorSchemeQuery = (doc: Document, scheme: "dark" | "light"): boolean => {
  const styleBlocks = Array.from(doc.querySelectorAll("head style")).map(
    (style) => style.textContent ?? "",
  );
  const pattern = new RegExp(
    `@media\\s*\\(\\s*prefers-color-scheme\\s*:\\s*${scheme}\\s*\\)\\s*\\{[^}]*(html|body|main|\\.container|#container|#root|#app|\\.app|#main|\\.main|\\.content|#content)[^}]*\\}`,
    "i",
  );
  return styleBlocks.some((style) => pattern.test(style));
};

export const extractBackgroundColor = (
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

export const hasDarkModeSupport = (doc: Document, rawHtml: string): boolean => {
  if (!hasMeaningfulColorSchemeQuery(doc, "dark")) return false;
  const darkBg = extractBackgroundColor(doc, rawHtml, "dark");
  return darkBg !== null && calculateBrightness(darkBg) < 0.3;
};

export const hasLightInDarkMode = (doc: Document, rawHtml: string): boolean => {
  if (!hasMeaningfulColorSchemeQuery(doc, "dark")) return false;
  const darkBg = extractBackgroundColor(doc, rawHtml, "dark");
  return darkBg !== null && calculateBrightness(darkBg) > 0.7;
};

export const hasDarkInLightMode = (doc: Document, rawHtml: string): boolean => {
  if (!hasMeaningfulColorSchemeQuery(doc, "light")) return false;
  const lightBg = extractBackgroundColor(doc, rawHtml, "light");
  return lightBg !== null && calculateBrightness(lightBg) < 0.3;
};

export const hasAsciiArtComment = (rawHtml: string): boolean => {
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

export const isLikelyCodeComment = (comment: string): boolean => {
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
