// src/achievements/anarchic_style_sheets/main.ts
var rule = {
  id: "anarchic_style_sheets.main",
  title: "Anarchic Style Sheets",
  group: "anarchic_style_sheets",
  description: "Page has <strong>#{@required_styles}</strong> or more <code>&lt;style&gt;</code> elements scattered within the <code>&lt;body&gt;</code>",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelectorAll("body style").length >= 3
};

// src/achievements/utils.ts
var ALL_HTML_ELEMENTS = [
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
  "xmp"
];
var DEPRECATED_ELEMENTS = /* @__PURE__ */ new Set([
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
  "xmp"
]);
var VOID_ELEMENTS = [
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
  "wbr"
];
var BULLET_CHARS = [
  "\u2022",
  "\xB7",
  "\u25CF",
  "\u25CB",
  "\u25C6",
  "\u25C7",
  "\u25A0",
  "\u25A1",
  "\u25AA",
  "\u25AB",
  "\u25B6",
  "\u25BA",
  "\u25B8",
  "\u25B9",
  "\u25BC",
  "\u25BD",
  "\u25BE",
  "\u25BF",
  "\u25D8",
  "\u25D9",
  "\u25E6",
  "\u2605",
  "\u2606",
  "\u2713",
  "\u2714",
  "\u2717",
  "\u2718",
  "\u2043",
  "\u2055",
  "\u204E",
  "\u204D",
  "\u29BF",
  "\u29BE",
  "\u29EB",
  "\u29EE"
];
var COLOR_KEYWORDS = {
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
  slategrey: "#708090"
};
var getClassRatio = (doc, rawHtml) => {
  const classesSize = Array.from(doc.querySelectorAll("*[class]")).map((el) => el.getAttribute("class") ?? "").join(" ").length;
  if (classesSize === 0 || rawHtml.length === 0) return 0;
  return Number((classesSize / rawHtml.length).toFixed(2));
};
var getDivRatio = (doc) => {
  const divCount = doc.querySelectorAll("div").length;
  const elementCount = doc.querySelectorAll("*").length;
  if (elementCount === 0) return 0;
  return Number((divCount / elementCount).toFixed(2));
};
var countValidElementsUsed = (doc) => {
  const valid = new Set(ALL_HTML_ELEMENTS);
  const used = new Set(
    Array.from(doc.querySelectorAll("*")).map((el) => el.tagName.toLowerCase()).filter((tag) => valid.has(tag))
  );
  return used.size;
};
var missingHtmlElements = (doc) => {
  const used = new Set(Array.from(doc.querySelectorAll("*")).map((el) => el.tagName.toLowerCase()));
  return new Set(ALL_HTML_ELEMENTS.filter((tag) => !used.has(tag)));
};
var attrContentLength = (doc, attribute) => Array.from(doc.querySelectorAll(`*[${attribute}]`)).map((el) => el.getAttribute(attribute) ?? "").join(" ").length;
var hasOnAttribute = (doc) => Array.from(doc.querySelectorAll("*")).some(
  (el) => Array.from(el.attributes).some((attr) => attr.name.startsWith("on"))
);
var hasStyleAttribute = (doc) => Array.from(doc.querySelectorAll("*")).some((el) => el.hasAttribute("style"));
var countUniqueExternalDomains = (doc) => {
  const domains = /* @__PURE__ */ new Set();
  for (const link of Array.from(doc.querySelectorAll("a[href]"))) {
    const href = (link.getAttribute("href") ?? "").trim();
    if (/^(javascript|mailto|tel|data|vbscript):/i.test(href) || href.startsWith("#")) continue;
    if (!href.includes("://") && !href.startsWith("//")) continue;
    try {
      const url = new URL(href.startsWith("//") ? `https:${href}` : href);
      if (!["http:", "https:"].includes(url.protocol)) continue;
      if (url.hostname) domains.add(url.hostname);
    } catch {
    }
  }
  return domains.size;
};
var detectWebFrameworks = (doc) => {
  const frameworks = [];
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
var containsCustomElement = (rawHtml) => /<([A-Za-z0-9]+-[A-Za-z0-9]+)(\s+[^>]*)?>.*<\/\1>/s.test(rawHtml);
var isYoutubeUrl = (value) => {
  const normalized = value.trim();
  if (!normalized) return false;
  try {
    const url = new URL(
      normalized.startsWith("//") ? `https:${normalized}` : normalized,
      "https://example.com"
    );
    const hostname = url.hostname.toLowerCase();
    return hostname === "youtube.com" || hostname.endsWith(".youtube.com") || hostname === "youtu.be" || hostname.endsWith(".youtu.be");
  } catch {
    return false;
  }
};
var longestSingleChildChain = (element) => {
  const childElements = Array.from(element.children);
  if (childElements.length === 0) return 1;
  if (childElements.length === 1) return 1 + longestSingleChildChain(childElements[0]);
  return Math.max(0, ...childElements.map((child) => longestSingleChildChain(child)));
};
var collectDepths = (element, currentDepth) => {
  const depths = [];
  for (const child of Array.from(element.children)) {
    depths.push(currentDepth);
    depths.push(...collectDepths(child, currentDepth + 1));
  }
  return depths;
};
var analyzeVoidElements = (rawHtml) => {
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
var normalizeColor = (input2) => {
  const color = input2.trim().toLowerCase();
  if (color.startsWith("#")) return color;
  if (COLOR_KEYWORDS[color]) return COLOR_KEYWORDS[color];
  const rgbMatch = color.match(/rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)/i);
  if (rgbMatch) {
    const [r, g, b] = rgbMatch.slice(1, 4).map((value) => Math.max(0, Math.min(255, Number(value))));
    return `#${r.toString(16).padStart(2, "0")}${g.toString(16).padStart(2, "0")}${b.toString(16).padStart(2, "0")}`;
  }
  const rgbPercentMatch = color.match(/rgba?\(\s*(\d+)%\s*,\s*(\d+)%\s*,\s*(\d+)%/i);
  if (rgbPercentMatch) {
    const [r, g, b] = rgbPercentMatch.slice(1, 4).map((value) => Math.max(0, Math.min(255, Math.round(Number(value) * 255 / 100))));
    return `#${r.toString(16).padStart(2, "0")}${g.toString(16).padStart(2, "0")}${b.toString(16).padStart(2, "0")}`;
  }
  return null;
};
var hexToRgb = (hex) => {
  const normalized = hex.replace(/^#/, "");
  if (normalized.length === 3) {
    const [r, g, b] = normalized.split("");
    return [parseInt(`${r}${r}`, 16), parseInt(`${g}${g}`, 16), parseInt(`${b}${b}`, 16)];
  }
  if (normalized.length === 6) {
    return [
      parseInt(normalized.slice(0, 2), 16),
      parseInt(normalized.slice(2, 4), 16),
      parseInt(normalized.slice(4, 6), 16)
    ];
  }
  return [255, 255, 255];
};
var calculateBrightness = (color) => {
  const normalized = normalizeColor(color);
  if (!normalized) return 1;
  const [r, g, b] = hexToRgb(normalized);
  return (0.299 * r + 0.587 * g + 0.114 * b) / 255;
};
var extractFromMediaQuery = (css, scheme) => {
  const regex = new RegExp(
    `@media\\s*\\(\\s*prefers-color-scheme\\s*:\\s*${scheme}\\s*\\)[^{]*{[^}]*(background(-color)?:\\s*([^;]*))`,
    "i"
  );
  const match = css.match(regex);
  if (!match) return null;
  const color = match[3] ?? "";
  return normalizeColor(color);
};
var extractFromInlineStyle = (style) => {
  const match = style.match(/background(-color)?:\s*([^;]*)/i);
  if (!match) return null;
  return normalizeColor(match[2]);
};
var extractGeneralBackground = (htmlStyle, bodyStyle, styleContent) => {
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
var hasMeaningfulColorSchemeQuery = (doc, scheme) => {
  const styleBlocks = Array.from(doc.querySelectorAll("head style")).map(
    (style) => style.textContent ?? ""
  );
  const pattern = new RegExp(
    `@media\\s*\\(\\s*prefers-color-scheme\\s*:\\s*${scheme}\\s*\\)\\s*\\{[^}]*(html|body|main|\\.container|#container|#root|#app|\\.app|#main|\\.main|\\.content|#content)[^}]*\\}`,
    "i"
  );
  return styleBlocks.some((style) => pattern.test(style));
};
var extractBackgroundColor = (doc, rawHtml, colorScheme) => {
  const styleContent = Array.from(doc.querySelectorAll("style")).map((style) => style.textContent ?? "").join(" ");
  const htmlStyle = doc.documentElement.getAttribute("style") ?? "";
  const bodyStyle = doc.body?.getAttribute("style") ?? "";
  const allCss = `${styleContent} ${htmlStyle} ${bodyStyle}`;
  const mediaColor = colorScheme ? extractFromMediaQuery(allCss, colorScheme) : null;
  if (mediaColor) return mediaColor;
  return extractGeneralBackground(htmlStyle, bodyStyle, styleContent) ?? normalizeColor(rawHtml) ?? null;
};
var hasDarkModeSupport = (doc, rawHtml) => {
  if (!hasMeaningfulColorSchemeQuery(doc, "dark")) return false;
  const darkBg = extractBackgroundColor(doc, rawHtml, "dark");
  return darkBg !== null && calculateBrightness(darkBg) < 0.3;
};
var hasLightInDarkMode = (doc, rawHtml) => {
  if (!hasMeaningfulColorSchemeQuery(doc, "dark")) return false;
  const darkBg = extractBackgroundColor(doc, rawHtml, "dark");
  return darkBg !== null && calculateBrightness(darkBg) > 0.7;
};
var hasDarkInLightMode = (doc, rawHtml) => {
  if (!hasMeaningfulColorSchemeQuery(doc, "light")) return false;
  const lightBg = extractBackgroundColor(doc, rawHtml, "light");
  return lightBg !== null && calculateBrightness(lightBg) < 0.3;
};
var hasAsciiArtComment = (rawHtml) => {
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
    /\\\\_\/\\\\/
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
    "@"
  ];
  for (const comment of comments) {
    const lines = comment.split("\n").map((line) => line.trim()).filter(Boolean);
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
var isLikelyCodeComment = (comment) => {
  const trimmed = comment.trim();
  if (!trimmed) return false;
  const definitiveMarkers = [
    "[if",
    "function",
    "var ",
    "class=",
    "<script",
    "<\/script>",
    "<![endif]"
  ];
  if (definitiveMarkers.some((marker) => trimmed.includes(marker))) return true;
  const lines = trimmed.split("\n").map((line) => line.trim()).filter(Boolean);
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

// src/achievements/ascii_art/main.ts
var rule2 = {
  id: "ascii_art.main",
  title: "ASCII Art",
  group: "ascii_art",
  description: "Page contains an ASCII art HTML <code>&lt;!-- comment --&gt;</code>",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => hasAsciiArtComment(rawHtml)
};

// src/achievements/backwards_compatibility/main.ts
var rule3 = {
  id: "backwards_compatibility.main",
  title: "Backwards Compatibility",
  group: "backwards_compatibility",
  description: "Page contains an <code>&lt;!--[if IE]&gt;...&lt;![endif]--&gt;</code> comment",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => /<!--\s*\[\s*if\s+IE\s*\].*?<!\[endif\]\s*-->/is.test(rawHtml)
};

// src/achievements/bigheaded/main.ts
var rule4 = {
  id: "bigheaded.main",
  title: "Bigheaded",
  group: "bigheaded",
  description: "Page <code>&lt;head&gt;</code> contains <strong>25</strong> or more elements",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelectorAll("head *").length >= 25
};

// src/achievements/bind_person_hater/main.ts
var rule5 = {
  id: "bind_person_hater.main",
  title: "Blind Person Hater",
  group: "blind_person_hater",
  description: "Majority of images lack <code>alt</code> attributes and/or no ARIA attributes appear on the page",
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    const imgs = Array.from(doc.querySelectorAll("img"));
    const missingAltCount = imgs.filter((img) => {
      const alt = img.getAttribute("alt");
      return alt === null || alt === "";
    }).length;
    const ariaPresent = Array.from(doc.querySelectorAll("*")).some(
      (el) => Array.from(el.attributes).some((attr) => attr.name.startsWith("aria-"))
    );
    const missingAlt = imgs.length > 0 && missingAltCount > imgs.length / 2;
    return missingAlt && !ariaPresent;
  }
};

// src/achievements/bob_ross/main.ts
var rule6 = {
  id: "bob_ross.main",
  title: "Bob Ross",
  group: "bob_ross",
  description: "Page includes a <code>&lt;canvas&gt;</code> or <code>&lt;picture&gt;</code> element",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector("canvas, picture") !== null
};

// src/achievements/bootstrap/main.ts
var rule7 = {
  id: "bootstrap.main",
  title: "Not like the other girls",
  group: "bootstrap",
  description: 'Page contains links to <a href="https://getbootstrap.com/" target="_blank">Bootstrap</a> CSS or JS',
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector('link[href*="bootstrap"], script[src*="bootstrap"]') !== null
};

// src/achievements/bullet_hell/main.ts
var rule8 = {
  id: "bullet_hell.main",
  title: "Bullet Hell",
  group: "bullet_hell",
  description: "Page uses unicode bullet points (\u2022 \u25C6 \u2605) to create a list instead of using <code>&lt;ul&gt;</code>",
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    const htmlLists = doc.querySelectorAll("ul, ol").length;
    const bulletElements = Array.from(doc.querySelectorAll("p, div, span, h1, h2, h3, h4, h5, h6")).map((el) => (el.textContent ?? "").trim()).filter((text) => BULLET_CHARS.some((bullet) => text.startsWith(bullet)));
    const textWithBullets = Array.from(doc.querySelectorAll("*:not(ul):not(ol):not(li)")).map((el) => el.textContent ?? "").some((text) => {
      const bulletLines = text.split(/\r?\n/).map((line) => line.trim()).filter((line) => BULLET_CHARS.some((bullet) => line.startsWith(bullet)));
      return bulletLines.length >= 2;
    });
    return (bulletElements.length >= 2 || textWithBullets) && htmlLists === 0;
  }
};

// src/achievements/class_warfare/main.ts
var rule9 = {
  id: "class_warfare.main",
  title: "Class Warfare",
  group: "class_warfare",
  description: "Page includes an element with more than <strong>50</strong> classes",
  hierarchy: "standard",
  evaluate: ({ doc }) => Array.from(doc.querySelectorAll("*[class]")).some(
    (el) => (el.getAttribute("class") ?? "").trim().split(/\s+/).filter(Boolean).length > 50
  )
};

// src/achievements/classy/bronze.ts
var rule10 = {
  id: "classy.bronze",
  title: "Classy",
  group: "classy",
  description: "HTML <code>class</code> attributes make up more than <strong>10%</strong> of the page's size",
  hierarchy: "bronze",
  evaluate: ({ doc, rawHtml }) => getClassRatio(doc, rawHtml) > 0.1
};

// src/achievements/classy/gold.ts
var rule11 = {
  id: "classy.gold",
  title: "Aristocratic",
  group: "classy",
  description: "HTML <code>class</code> attributes make up more than <strong>one third</strong> of the page's size",
  hierarchy: "gold",
  evaluate: ({ doc, rawHtml }) => getClassRatio(doc, rawHtml) > 0.333
};

// src/achievements/classy/platinum.ts
var rule12 = {
  id: "classy.platinum",
  title: "Opulent",
  group: "classy",
  description: "HTML <code>class</code> attributes make up more than <strong>50%</strong> of the page's size",
  hierarchy: "platinum",
  evaluate: ({ doc, rawHtml }) => getClassRatio(doc, rawHtml) > 0.5
};

// src/achievements/classy/silver.ts
var rule13 = {
  id: "classy.silver",
  title: "Sophisticated",
  group: "classy",
  description: "HTML <code>class</code> attributes make up more than <strong>25%</strong> of the page's size",
  hierarchy: "silver",
  evaluate: ({ doc, rawHtml }) => getClassRatio(doc, rawHtml) > 0.25
};

// src/achievements/commentator_in_chief/main.ts
var COMMENT_REGEX = /<!--[\s\S]*?-->/g;
var rule14 = {
  id: "commentator_in_chief.main",
  title: "Commentator-in-Chief",
  group: "commentator_in_chief",
  description: "Page contains more than <strong>10</strong> <code>&lt;!-- comments --&gt;</code>",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => (rawHtml.match(COMMENT_REGEX) ?? []).length > 10
};

// src/achievements/cross_platform/main.ts
var VENDOR_PREFIX_REGEX = /-webkit-|-moz-|-o-|-ms-/;
var rule15 = {
  id: "cross_platform.main",
  title: "Fragmented Ecosystem",
  group: "cross_platform",
  description: "Page contains browser-specific CSS, e.g., <code>-webkit-</code>, <code>-moz-</code>, <code>-o-</code>, <code>-ms-</code>",
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    const inlineCss = Array.from(doc.querySelectorAll("style")).map((el) => el.textContent ?? "").join(" ");
    const attrCss = Array.from(doc.querySelectorAll("[style]")).map((el) => el.getAttribute("style") ?? "").join(" ");
    return VENDOR_PREFIX_REGEX.test(`${inlineCss} ${attrCss}`);
  }
};

// src/achievements/data_driven/main.ts
var rule16 = {
  id: "data_driven.main",
  title: "Data Driven",
  group: "data_driven",
  description: "More than <strong>8</strong> elements on the page have <code>data-</code> attributes",
  hierarchy: "standard",
  evaluate: ({ doc }) => Array.from(doc.querySelectorAll("*")).filter(
    (el) => Array.from(el.attributes).some((attr) => attr.name.startsWith("data-"))
  ).length > 8
};

// src/achievements/dictionary_enthusiast/main.ts
var rule17 = {
  id: "dictionary_enthusiast.main",
  title: "Dictionary Enthusiast",
  group: "dictionary_enthusiast",
  description: "Page uses definition elements (<code>&lt;dfn&gt;</code> or <code>&lt;dl&gt;</code> with <code>&lt;dt&gt;</code> and <code>&lt;dd&gt;</code>)",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector("dfn") !== null || doc.querySelector("dl dt") !== null && doc.querySelector("dl dd") !== null
};

// src/achievements/div_soup/bronze.ts
var rule18 = {
  id: "div_soup.bronze",
  title: "Div Broth",
  group: "div_soup",
  description: "More than <strong>25%</strong> of the HTML elements in the page are <code>&lt;div&gt;</code> elements",
  hierarchy: "bronze",
  evaluate: ({ doc }) => getDivRatio(doc) > 0.25
};

// src/achievements/div_soup/gold.ts
var rule19 = {
  id: "div_soup.gold",
  title: "Div Stew",
  group: "div_soup",
  description: "More than <strong>75%</strong> of the HTML elements in the page are <code>&lt;div&gt;</code> elements",
  hierarchy: "gold",
  evaluate: ({ doc }) => getDivRatio(doc) > 0.75
};

// src/achievements/div_soup/platinum.ts
var rule20 = {
  id: "div_soup.platinum",
  title: "Div Casserole",
  group: "div_soup",
  description: "More than <strong>90%</strong> of the HTML elements in the page are <code>&lt;div&gt;</code> elements",
  hierarchy: "platinum",
  evaluate: ({ doc }) => getDivRatio(doc) > 0.9
};

// src/achievements/div_soup/silver.ts
var rule21 = {
  id: "div_soup.silver",
  title: "Div Soup",
  group: "div_soup",
  description: "More than <strong>50%</strong> of the HTML elements in the page are <code>&lt;div&gt;</code> elements",
  hierarchy: "silver",
  evaluate: ({ doc }) => getDivRatio(doc) > 0.5
};

// src/achievements/dynamic_content/main.ts
var rule22 = {
  id: "dynamic_content.main",
  title: "Dynamic Content",
  group: "dynamic_content",
  description: "Page uses an <code>&lt;output&gt;</code> element",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector("output") !== null
};

// src/achievements/empty_calories/main.ts
var rule23 = {
  id: "empty_calories.main",
  title: "Empty Calories",
  group: "empty_calories",
  description: "Page contains <strong>10</strong> or more empty <code>&lt;div&gt;</code> or <code>&lt;span&gt;</code> elements",
  hierarchy: "standard",
  evaluate: ({ doc }) => Array.from(doc.querySelectorAll("div, span")).filter(
    (el) => el.children.length === 0 && (el.textContent ?? "").trim() === ""
  ).length >= 10
};

// src/achievements/favicon_fanatic/main.ts
var rule24 = {
  id: "favicon_fanatic.main",
  title: "Favicon Fanatic",
  group: "favicon_fanatic",
  description: 'The head has more than <strong>3</strong> <code>&lt;link rel="icon"&gt;</code> elements',
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelectorAll('head link[rel="icon"]').length > 3
};

// src/achievements/flashbang/gold.ts
var rule25 = {
  id: "flashbang.gold",
  title: "Flashbang",
  group: "seared_retinas",
  description: "The primary background color is <strong>light</strong> when the user prefers <strong>dark mode</strong>",
  hierarchy: "gold",
  evaluate: ({ doc, rawHtml }) => {
    if (hasDarkModeSupport(doc, rawHtml)) return false;
    const bg = extractBackgroundColor(doc, rawHtml);
    return bg !== null && calculateBrightness(bg) > 0.85;
  }
};

// src/achievements/flashbang/platinum.ts
var rule26 = {
  id: "flashbang.platinum",
  title: "Chaotic Evil",
  group: "seared_retinas",
  description: "The primary background color is light when the user prefers dark mode and dark when the user prefers light mode",
  hierarchy: "platinum",
  evaluate: ({ doc, rawHtml }) => {
    const lightInDark = hasLightInDarkMode(doc, rawHtml);
    const darkInLight = hasDarkInLightMode(doc, rawHtml);
    return lightInDark || darkInLight;
  }
};

// src/achievements/form_fanatic/main.ts
var REQUIRED_INPUT_TYPES = 5;
var rule27 = {
  id: "form_fanatic.main",
  title: "Form Fanatic",
  group: "form_fanatic",
  description: "Page has a <code>&lt;form&gt;</code> containing <strong>5</strong> or more different input types",
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    const forms = Array.from(doc.querySelectorAll("form"));
    if (forms.length === 0) {
      return false;
    }
    const uniqueInputTypes = /* @__PURE__ */ new Set();
    for (const form2 of forms) {
      for (const input2 of form2.querySelectorAll("input")) {
        uniqueInputTypes.add((input2.getAttribute("type") ?? "text").toLowerCase());
      }
      if (form2.querySelector("textarea")) {
        uniqueInputTypes.add("textarea");
      }
      if (form2.querySelector("select")) {
        uniqueInputTypes.add("select");
      }
    }
    return uniqueInputTypes.size >= REQUIRED_INPUT_TYPES;
  }
};

// src/achievements/framework_phobia/main.ts
var rule28 = {
  id: "framework_phobia.main",
  title: "Framework Phobia",
  group: "framework_phobia",
  description: "Page contains a custom HTML element and does not use a JS framework",
  hierarchy: "standard",
  evaluate: ({ doc, rawHtml }) => {
    const frameworks = detectWebFrameworks(doc);
    return containsCustomElement(rawHtml) && frameworks.length === 0;
  }
};

// src/achievements/htmx/main.ts
var rule29 = {
  id: "htmx.main",
  title: "HTMX Simp",
  group: "htmx",
  description: 'Page contains a reference to <a href="https://htmx.org" target="_blank">HTMX</a>',
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => rawHtml.toLowerCase().includes("htmx")
};

// src/achievements/hydra/main.ts
var rule30 = {
  id: "hydra.main",
  title: "Hydra",
  group: "hydra",
  description: "Page contains multiple <code>&lt;h1&gt;</code> elements",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelectorAll("h1").length > 1
};

// src/achievements/hyperlink_collector/bronze.ts
var rule31 = {
  id: "hyperlink_collector.bronze",
  title: "Hyperlink Collector",
  group: "hyperlink_collector",
  description: "Page contains links to at least <strong>#{@min_domains}</strong> different external domains",
  hierarchy: "bronze",
  evaluate: ({ doc }) => countUniqueExternalDomains(doc) >= 5
};

// src/achievements/hyperlink_collector/gold.ts
var rule32 = {
  id: "hyperlink_collector.gold",
  title: "Hyperlink Curator",
  group: "hyperlink_collector",
  description: "Page contains links to at least <strong>#{@min_domains}</strong> different external domains",
  hierarchy: "gold",
  evaluate: ({ doc }) => countUniqueExternalDomains(doc) >= 25
};

// src/achievements/hyperlink_collector/platinum.ts
var rule33 = {
  id: "hyperlink_collector.platinum",
  title: "Hyperlink Connoisseur",
  group: "hyperlink_collector",
  description: "Page contains links to at least <strong>#{@min_domains}</strong> different external domains",
  hierarchy: "platinum",
  evaluate: ({ doc }) => countUniqueExternalDomains(doc) >= 50
};

// src/achievements/hyperlink_collector/silver.ts
var rule34 = {
  id: "hyperlink_collector.silver",
  title: "Hyperlink Custodian",
  group: "hyperlink_collector",
  description: "Page contains links to at least <strong>#{@min_domains}</strong> different external domains",
  hierarchy: "silver",
  evaluate: ({ doc }) => countUniqueExternalDomains(doc) >= 10
};

// src/achievements/impa/main.ts
var rule35 = {
  id: "impa.main",
  title: "Impa",
  group: "impa",
  description: "Page uses the Shadow DOM",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => /\.attachShadow\s*\(|<template\s+[^>]*shadowroot\s*=\s*["'](?:open|closed)["'][^>]*>/i.test(
    rawHtml
  )
};

// src/achievements/important_person/main.ts
var rule36 = {
  id: "important_person.main",
  title: "!important person",
  group: "important_person",
  description: "The phrase <code>!important</code> appears <strong>10</strong> or more times on the page",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => (rawHtml.match(/!important/g) ?? []).length >= 10
};

// src/achievements/locality_of_appearance/main.ts
var rule37 = {
  id: "locality_of_appearance.main",
  title: "Locality of Appearance",
  group: "locality_of_appearance",
  description: "Page has more CSS in <code>style</code> attributes than <code>class</code> attributes",
  hierarchy: "standard",
  evaluate: ({ doc }) => attrContentLength(doc, "style") > attrContentLength(doc, "class")
};

// src/achievements/lorem_ipsum/main.ts
var rule38 = {
  id: "lorem_ipsum.main",
  title: "Textus Vicarious",
  group: "lorem_ipsum",
  description: '<i>Pagina locutionem "lorem ipsum" continet</i>',
  hierarchy: "standard",
  evaluate: ({ doc }) => (doc.body?.textContent ?? "").toLowerCase().includes("lorem ipsum")
};

// src/achievements/master_of_elements/bronze.ts
var rule39 = {
  id: "master_of_elements.bronze",
  title: "Elementary Particles",
  group: "master_of_elements",
  description: "Page uses at least <strong>#{@required_elements}</strong> different HTML elements",
  hierarchy: "bronze",
  evaluate: ({ doc }) => countValidElementsUsed(doc) >= 17
};

// src/achievements/master_of_elements/gold.ts
var rule40 = {
  id: "master_of_elements.gold",
  title: "Element Alchemist",
  group: "master_of_elements",
  description: "Page uses at least <strong>#{@required_elements}</strong> different HTML elements",
  hierarchy: "gold",
  evaluate: ({ doc }) => countValidElementsUsed(doc) >= 118
};

// src/achievements/master_of_elements/platinum.ts
var rule41 = {
  id: "master_of_elements.platinum",
  title: "Master of All #{total_elements} Elements",
  group: "master_of_elements",
  description: "Page uses <strong>every HTML element</strong>, even the deprecated ones",
  hierarchy: "platinum",
  evaluate: ({ doc }) => missingHtmlElements(doc).size === 0
};

// src/achievements/master_of_elements/silver.ts
var rule42 = {
  id: "master_of_elements.silver",
  title: "Elementary, My Dear Watson",
  group: "master_of_elements",
  description: "Page uses at least <strong>#{@required_elements}</strong> different HTML elements",
  hierarchy: "silver",
  evaluate: ({ doc }) => countValidElementsUsed(doc) >= 60
};

// src/achievements/millionth_visitor/main.ts
var rule43 = {
  id: "millionth_visitor.main",
  title: "Millionth Visitor!!!",
  group: "millionth_visitor",
  description: "Page uses a <code>&lt;blink&gt;</code> or <code>&lt;marquee&gt;</code> element",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector("blink, marquee") !== null
};

// src/achievements/ok_boomer/main.ts
var rule44 = {
  id: "ok_boomer.main",
  title: "OK Boomer",
  group: "ok_boomer",
  description: "Page uses a deprecated HTML element",
  hierarchy: "standard",
  evaluate: ({ doc }) => Array.from(DEPRECATED_ELEMENTS).some((tag) => doc.querySelector(tag) !== null)
};

// src/achievements/oops_all_frameworks/main.ts
var rule45 = {
  id: "oops_all_frameworks.main",
  title: "Oops, All Frameworks",
  group: "oops_all_frameworks",
  description: "Page uses React, Vue, and Angular simultaneously",
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    const frameworks = detectWebFrameworks(doc);
    return ["React", "Vue", "Angular"].every((framework) => frameworks.includes(framework));
  }
};

// src/achievements/phd_purist/main.ts
var rule46 = {
  id: "phd_purist.main",
  title: "PhD Purist",
  group: "phd_purist",
  description: "Use the <code>&lt;math&gt;</code> element for something nontrivial",
  hierarchy: "standard",
  evaluate: ({ doc }) => Array.from(doc.querySelectorAll("math")).some(
    (math) => math.children.length >= 5 || math.querySelector("mfrac, msqrt, mroot, msubsup, munderover, mtable") !== null
  )
};

// src/achievements/preemptive_strike/main.ts
var rule47 = {
  id: "preemptive_strike.main",
  title: "Preemptive Strike",
  group: "preemptive_strike",
  description: 'Page includes a <code>&lt;link rel="preload"&gt;</code>, <code>&lt;link rel="dns-prefetch"&gt;</code>, or <code>&lt;link rel="preconnect"&gt;</code>',
  hierarchy: "standard",
  evaluate: ({ doc }) => Array.from(doc.querySelectorAll("link")).some((link) => {
    const rel = (link.getAttribute("rel") ?? "").toLowerCase();
    return rel.includes("preload") || rel.includes("dns-prefetch") || rel.includes("preconnect");
  })
};

// src/achievements/progressive/main.ts
var rule48 = {
  id: "progressive.main",
  title: "Progressive",
  group: "progressive",
  description: "Page contains both a <code>&lt;progress&gt;</code> and <code>&lt;meter&gt;</code> element",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector("progress") !== null && doc.querySelector("meter") !== null
};

// src/achievements/quirky/main.ts
var rule49 = {
  id: "quirky.main",
  title: "Quirky",
  group: "quirky",
  description: "Page renders in quirks mode",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => !/<!DOCTYPE html>/i.test(rawHtml)
};

// src/achievements/regressive_enhancement/main.ts
var rule50 = {
  id: "regressive_enhancement.main",
  title: "Regressive Enhancement",
  group: "regressive_enhancement",
  description: "Page includes a <code>&lt;noscript&gt;</code> element with barely anything in it",
  hierarchy: "standard",
  evaluate: ({ doc }) => Array.from(doc.querySelectorAll("noscript")).some(
    (el) => (el.textContent ?? "").replace(/\s/g, "").length < 100
  )
};

// src/achievements/scriptonite/gold.ts
var rule51 = {
  id: "scriptonite.gold",
  title: "i use lynx btw",
  group: "the_web_is_for_documents",
  description: "No JavaScript, CSS, or images appear in the page",
  hierarchy: "gold",
  evaluate: ({ doc }) => doc.querySelector("script") === null && !hasOnAttribute(doc) && !hasStyleAttribute(doc) && doc.querySelector('style, link[rel="stylesheet"], img') === null
};

// src/achievements/scriptonite/platinum.ts
var rule52 = {
  id: "scriptonite.platinum",
  title: "Always bet on text",
  group: "the_web_is_for_documents",
  description: "Page is entirely plaintext - no CSS, JavaScript, or HTML elements",
  hierarchy: "platinum",
  evaluate: ({ doc, rawHtml }) => {
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
      (child) => child.tagName.toLowerCase() === "meta"
    );
    return preAttrsOk && headOk && html.tagName.toLowerCase() === "html";
  }
};

// src/achievements/scriptonite/silver.ts
var rule53 = {
  id: "scriptonite.silver",
  title: "Scriptonite",
  group: "the_web_is_for_documents",
  description: "No <code>&lt;script&gt;</code> tags or <code>on</code> attributes appear in the page",
  hierarchy: "silver",
  evaluate: ({ doc }) => doc.querySelector("script") === null && !hasOnAttribute(doc)
};

// src/achievements/self_love/main.ts
var rule54 = {
  id: "self_love.main",
  title: "Self Love",
  group: "self_love",
  description: 'Page contains an <code>&lt;a href="#"&gt;</code> element',
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector('a[href="#"]') !== null
};

// src/achievements/semantic_snob/gold.ts
var rule55 = {
  id: "semantic_snob.gold",
  title: "Semantic Snob",
  group: "semantics",
  description: "Page uses each of the following elements: <code>&lt;header&gt;</code>, <code>&lt;nav&gt;</code>, <code>&lt;main&gt;</code>, <code>&lt;article&gt;</code>, <code>&lt;section&gt;</code>, <code>&lt;aside&gt;</code>, <code>&lt;footer&gt;</code>",
  hierarchy: "gold",
  evaluate: ({ doc }) => ["header", "nav", "main", "article", "section", "aside", "footer"].every(
    (tag) => doc.querySelector(tag) !== null
  )
};

// src/achievements/semantic_snob/platinum.ts
var rule56 = {
  id: "semantic_snob.platinum",
  title: "Semantic Psychopath",
  group: "semantics",
  description: "Fulfill the criteria for <strong>Semantic Snob</strong> and also do not use a single <code>&lt;div&gt;</code> or <code>&lt;span&gt;</code>",
  hierarchy: "platinum",
  evaluate: ({ doc }) => ["header", "nav", "main", "article", "section", "aside", "footer"].every(
    (tag) => doc.querySelector(tag) !== null
  ) && doc.querySelector("div, span") === null
};

// src/achievements/seo_sleazeball/main.ts
var rule57 = {
  id: "seo_sleazeball.main",
  title: "SEO Sleazeball",
  group: "seo_sleazeball",
  description: "Page includes Open Graph, Twitter Card, and description <code>&lt;meta&gt;</code> tags",
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    const hasOpenGraph = doc.querySelector('meta[property^="og:"]') !== null;
    const hasTwitter = doc.querySelector('meta[name^="twitter:"]') !== null;
    const hasDescription = doc.querySelector('meta[name="description"]') !== null;
    return hasOpenGraph && hasTwitter && hasDescription;
  }
};

// src/achievements/slot_machine/main.ts
var rule58 = {
  id: "slot_machine.main",
  title: "Slot Machine",
  group: "slot_machine",
  description: "Page uses three <code>&lt;slot&gt;</code> elements in a row in a <code>&lt;template&gt;</code>",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector("template slot + slot + slot") !== null
};

// src/achievements/small_data/main.ts
var rule59 = {
  id: "small_data.main",
  title: "Small Data",
  group: "small_data",
  description: "Page uses <code>JSON-LD</code> or <code>Microdata</code>",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector('script[type="application/ld+json"], [itemscope], [itemtype], [itemprop]') !== null
};

// src/achievements/soap_box/main.ts
var rule60 = {
  id: "soap_box.main",
  title: "Soap Box",
  group: "soap_box",
  description: "Page contains an HTML <code>&lt;!-- comment --&gt;</code> with more than <strong>100</strong> words",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => Array.from(rawHtml.matchAll(/<!--([\s\S]*?)-->/g)).some(
    (match) => match[1].trim().split(/\s+/).filter(Boolean).length > 100
  )
};

// src/achievements/test_in_prod/main.ts
var rule61 = {
  id: "test_in_prod.main",
  title: "Test in Prod",
  group: "test_in_prod",
  description: "Page contains <code>console.log</code> statements",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => /console\.log\s*\(/.test(rawHtml)
};

// src/achievements/todo/bronze.ts
var rule62 = {
  id: "todo.bronze",
  title: "Unfinished Business",
  group: "todo",
  description: "Page contains the phrase <code>TODO</code>",
  hierarchy: "bronze",
  evaluate: ({ rawHtml }) => rawHtml.toUpperCase().includes("TODO")
};

// src/achievements/todo/gold.ts
var rule63 = {
  id: "todo.gold",
  title: "Todoism",
  group: "todo",
  description: "Page contains the phrase <code>TODO</code> a <strong>dozen</strong> or more times",
  hierarchy: "gold",
  evaluate: ({ rawHtml }) => rawHtml.toLowerCase().split("todo").length >= 12
};

// src/achievements/todo/silver.ts
var rule64 = {
  id: "todo.silver",
  title: "Fix me, please",
  group: "todo",
  description: "Page contains the phrase <code>TODO</code> at least <strong>3</strong> times",
  hierarchy: "silver",
  evaluate: ({ rawHtml }) => rawHtml.toLowerCase().split("todo").length >= 3
};

// src/achievements/too_meta/main.ts
var rule65 = {
  id: "too_meta.main",
  title: "Too Meta",
  group: "too_meta",
  description: "Page <code>&lt;head&gt;</code> includes <strong>8+</strong> <code>&lt;meta&gt;</code> elements",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelectorAll("head meta").length >= 8
};

// src/achievements/tower_of_babel/main.ts
var rule66 = {
  id: "tower_of_babel.main",
  title: "Tower of Babel",
  group: "tower_of_babel",
  description: "Page contains at least <strong>2</strong> <code>lang</code> attributes with different values",
  hierarchy: "standard",
  evaluate: ({ doc }) => new Set(
    Array.from(doc.querySelectorAll("*[lang]")).map((el) => el.getAttribute("lang") ?? "").filter(Boolean)
  ).size >= 2
};

// src/achievements/tree_shenanigans/deep_puddle.ts
var rule67 = {
  id: "tree_shenanigans.deep_puddle",
  title: "Deep Puddle",
  group: "tree_shenanigans",
  description: "The page body contains a descendant chain of at least <strong>#{@min_chain_length}</strong> elements \\\n        where each parent has only one child",
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    if (!doc.body) return false;
    return longestSingleChildChain(doc.body) >= 8;
  }
};

// src/achievements/tree_shenanigans/shallow_ocean.ts
var rule68 = {
  id: "tree_shenanigans.shallow_ocean",
  title: "Shallow Ocean",
  group: "tree_shenanigans",
  description: "Average depth of all elements inside <code>&lt;body&gt</code> is <strong>#{@max_avg_depth}</strong> or less",
  hierarchy: "standard",
  evaluate: ({ doc }) => {
    if (!doc.body) return false;
    const depths = collectDepths(doc.body, 1);
    if (depths.length === 0) return false;
    return depths.reduce((sum, depth) => sum + depth, 0) / depths.length <= 3;
  }
};

// src/achievements/type_hints/natural_language_static_typing.ts
var rule69 = {
  id: "type_hints.natural_language_static_typing",
  title: "Natural Language Static Typing",
  group: "semistatic_types",
  description: 'At least one text input (or textarea) has <code>spellcheck="true"</code>',
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector('input[spellcheck="true"], textarea[spellcheck="true"]') !== null
};

// src/achievements/type_hints/type_hints.ts
var rule70 = {
  id: "type_hints.type_hints",
  title: "Type Hints",
  group: "semistatic_types",
  description: "Page uses a <code>&lt;datalist&gt;</code> element",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector("datalist") !== null
};

// src/achievements/vintage/main.ts
var rule71 = {
  id: "vintage.main",
  title: "Vintage",
  group: "vintage",
  description: "Page uses a nested table layout",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector("table table") !== null
};

// src/achievements/void_elements/close_minded.ts
var rule72 = {
  id: "void_elements.close_minded",
  title: "Close-minded",
  group: "void_elements",
  description: "All void elements include a trailing slash (<code>&lt;img /&gt;</code>)",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => {
    const result = analyzeVoidElements(rawHtml);
    return result.total > 0 && result.withSlash === result.total;
  }
};

// src/achievements/void_elements/double_minded.ts
var rule73 = {
  id: "void_elements.double_minded",
  title: "Double-minded",
  group: "void_elements",
  description: "Some void elements include a trailing slash (<code>&lt;img /&gt;</code>) and some do not (<code>&lt;img&gt;</code>)",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => {
    const result = analyzeVoidElements(rawHtml);
    return result.total >= 2 && result.withSlash > 0 && result.withoutSlash > 0;
  }
};

// src/achievements/void_elements/open_minded.ts
var rule74 = {
  id: "void_elements.open_minded",
  title: "Open-minded",
  group: "void_elements",
  description: "No void elements include a trailing slash (<code>&lt;img&gt;</code>)",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => {
    const result = analyzeVoidElements(rawHtml);
    return result.total > 0 && result.withoutSlash === result.total;
  }
};

// src/achievements/we_do_things_a_little_different/main.ts
var rule75 = {
  id: "we_do_things_a_little_different.main",
  title: "We Do Things a Little Different Around Here",
  group: "we_do_things_a_little_different",
  description: "Nest a <code>&lt;div&gt;</code> inside a <code>&lt;span&gt;</code>",
  hierarchy: "standard",
  evaluate: ({ doc }) => Array.from(doc.querySelectorAll("span")).some((span) => span.querySelector("div") !== null)
};

// src/achievements/web_1_0_certified/main.ts
var rule76 = {
  id: "web_1_0_certified.main",
  title: "Web 1.0 Certified",
  group: "the_good_old_days",
  description: "Page is authored in HTML 3.2",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => /<!DOCTYPE\s+HTML\s+PUBLIC\s+"-\/\/W3C\/\/DTD\s+HTML\s+3\.2(\s+Final)?\/\/EN"/i.test(rawHtml)
};

// src/achievements/you_are_amazing_embed/main.ts
var rule77 = {
  id: "you_are_amazing_embed.main",
  title: "Incredible Embed",
  group: "embed",
  description: "Page embeds external content via <code>&lt;object&gt;</code>, <code>&lt;embed&gt;</code>, or <code>&lt;iframe&gt;</code>",
  hierarchy: "standard",
  evaluate: ({ doc }) => doc.querySelector("object, embed, iframe") !== null
};

// src/achievements/youtube_junkie/main.ts
var rule78 = {
  id: "youtube_junkie.main",
  title: "YouTube Junkie",
  group: "youtube_junkie",
  description: 'Page embeds <strong>#{@required_embeds}</strong> or more <a href="https://youtube.com" target="_blank">YouTube</a> videos',
  hierarchy: "standard",
  evaluate: ({ doc, rawHtml }) => {
    const iframeCount = doc.querySelectorAll(
      "iframe[src*='youtube.com'], iframe[src*='youtu.be']"
    ).length;
    const objectCount = doc.querySelectorAll(
      "object[data*='youtube.com'], object[data*='youtu.be']"
    ).length;
    const embedCount = doc.querySelectorAll(
      "embed[src*='youtube.com'], embed[src*='youtu.be']"
    ).length;
    const videoCount = Array.from(doc.querySelectorAll("video")).filter(
      (video) => Array.from(video.querySelectorAll("source")).some((source) => {
        const src = source.getAttribute("src") ?? "";
        return isYoutubeUrl(src);
      })
    ).length;
    const oldEmbedCount = (rawHtml.match(
      /<param\s+name=["']movie["']\s+value=["'](?:[^"']*?youtu(?:\.be|be\.com)[^"']*?)["']/gi
    ) ?? []).length;
    return iframeCount + objectCount + embedCount + videoCount + oldEmbedCount >= 3;
  }
};

// src/achievements/zalgo/main.ts
var rule79 = {
  id: "zalgo.main",
  title: "Zalgo",
  group: "zalgo",
  description: "Page contains <strong>Zalgo text</strong> (corrupted Unicode with combining characters)",
  hierarchy: "standard",
  evaluate: ({ rawHtml }) => /[^\p{M}][\p{M}]{3,}/u.test(rawHtml)
};

// src/achievements/registry.ts
var createAchievementRegistry = () => {
  const registeredRules = [];
  const registeredRulesById = /* @__PURE__ */ new Map();
  return {
    get rules() {
      return [...registeredRules];
    },
    get rulesById() {
      return new Map(registeredRulesById);
    },
    register: (rule80) => {
      const existingRule = registeredRulesById.get(rule80.id);
      if (existingRule !== void 0) {
        throw new Error(`Duplicate achievement ID registered: ${rule80.id}`);
      }
      registeredRules.push(rule80);
      registeredRulesById.set(rule80.id, rule80);
    }
  };
};

// src/achievements/index.ts
var registry = createAchievementRegistry();
registry.register(rule);
registry.register(rule2);
registry.register(rule3);
registry.register(rule4);
registry.register(rule5);
registry.register(rule6);
registry.register(rule7);
registry.register(rule8);
registry.register(rule9);
registry.register(rule10);
registry.register(rule11);
registry.register(rule12);
registry.register(rule13);
registry.register(rule14);
registry.register(rule15);
registry.register(rule16);
registry.register(rule17);
registry.register(rule18);
registry.register(rule19);
registry.register(rule20);
registry.register(rule21);
registry.register(rule22);
registry.register(rule23);
registry.register(rule24);
registry.register(rule25);
registry.register(rule26);
registry.register(rule27);
registry.register(rule28);
registry.register(rule29);
registry.register(rule30);
registry.register(rule31);
registry.register(rule32);
registry.register(rule33);
registry.register(rule34);
registry.register(rule35);
registry.register(rule36);
registry.register(rule37);
registry.register(rule38);
registry.register(rule39);
registry.register(rule40);
registry.register(rule41);
registry.register(rule42);
registry.register(rule43);
registry.register(rule44);
registry.register(rule45);
registry.register(rule46);
registry.register(rule47);
registry.register(rule48);
registry.register(rule49);
registry.register(rule50);
registry.register(rule51);
registry.register(rule52);
registry.register(rule53);
registry.register(rule54);
registry.register(rule55);
registry.register(rule56);
registry.register(rule57);
registry.register(rule58);
registry.register(rule59);
registry.register(rule60);
registry.register(rule61);
registry.register(rule62);
registry.register(rule63);
registry.register(rule64);
registry.register(rule65);
registry.register(rule66);
registry.register(rule67);
registry.register(rule68);
registry.register(rule69);
registry.register(rule70);
registry.register(rule71);
registry.register(rule72);
registry.register(rule73);
registry.register(rule74);
registry.register(rule75);
registry.register(rule76);
registry.register(rule77);
registry.register(rule78);
registry.register(rule79);
var rulesById = registry.rulesById;
var rules = registry.rules;

// src/analyze.ts
var hierarchyRank = {
  standard: 0,
  bronze: 1,
  silver: 2,
  gold: 3,
  platinum: 4
};
var parseHtml = (rawHtml, parser = new DOMParser()) => parser.parseFromString(rawHtml, "text/html");
var analyzeHtml = (rawHtml, parser) => {
  const document2 = parseHtml(rawHtml, parser);
  const context = { doc: document2, rawHtml };
  const earned = rules.filter((rule80) => rule80.evaluate(context));
  const earnedIds = new Set(earned.map((rule80) => rule80.id));
  const missed = rules.filter((rule80) => !earnedIds.has(rule80.id));
  return {
    rawHtml,
    document: document2,
    earned: sortAchievements(earned),
    missed: sortAchievements(missed),
    groups: groupEarnedAchievements(earned),
    totalAchievements: rules.length,
    earnedAchievements: earned.length
  };
};
var sortAchievements = (achievements) => [...achievements].sort((left, right) => {
  const hierarchyDelta = hierarchyRank[right.hierarchy] - hierarchyRank[left.hierarchy];
  if (hierarchyDelta !== 0) return hierarchyDelta;
  const groupDelta = left.group.localeCompare(right.group);
  if (groupDelta !== 0) return groupDelta;
  return left.title.localeCompare(right.title);
});
var groupEarnedAchievements = (achievements) => {
  const groups = /* @__PURE__ */ new Map();
  for (const achievement of achievements) {
    const existing = groups.get(achievement.group) ?? [];
    groups.set(achievement.group, [...existing, achievement]);
  }
  return Array.from(groups.entries()).map(([group, groupAchievements]) => ({
    group,
    title: titleizeGroup(group),
    earned: sortAchievements(groupAchievements),
    score: groupAchievements.reduce(
      (total, achievement) => total + hierarchyRank[achievement.hierarchy],
      0
    )
  })).sort((left, right) => {
    const scoreDelta = right.score - left.score;
    if (scoreDelta !== 0) return scoreDelta;
    const countDelta = right.earned.length - left.earned.length;
    if (countDelta !== 0) return countDelta;
    return left.title.localeCompare(right.title);
  });
};
var titleizeGroup = (group) => group.split("_").map((word) => word.charAt(0).toUpperCase() + word.slice(1)).join(" ");

// src/browser_app.ts
var sampleHtml = `<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Example</title>
    <meta name="description" content="A small sample page">
    <meta property="og:title" content="Example">
    <meta name="twitter:card" content="summary">
    <link rel="preconnect" href="https://example.com">
  </head>
  <body>
    <header><h1>Example</h1></header>
    <nav><a href="#content">Content</a></nav>
    <main id="content">
      <article>
        <section>
          <p>Paste your own HTML here and run the analyzer.</p>
        </section>
      </article>
    </main>
    <aside></aside>
    <footer></footer>
  </body>
</html>`;
var form = document.querySelector("#analyze-form");
var input = document.querySelector("#html-input");
var sampleButton = document.querySelector("#load-sample");
var clearButton = document.querySelector("#clear-input");
var summary = document.querySelector("#analysis-summary");
var results = document.querySelector("#analysis-results");
var renderEmptyState = (summaryElement, resultsElement) => {
  summaryElement.textContent = "Paste HTML and run the analyzer.";
  resultsElement.replaceChildren();
};
var renderAnalysis = (rawHtml, summaryElement, resultsElement) => {
  const html = rawHtml.trim();
  if (!html) {
    summaryElement.textContent = "Paste HTML before running the analyzer.";
    resultsElement.replaceChildren();
    return;
  }
  const analysis = analyzeHtml(html);
  summaryElement.textContent = `${analysis.earnedAchievements} of ${analysis.totalAchievements} achievements earned.`;
  resultsElement.replaceChildren();
  if (analysis.groups.length === 0) {
    resultsElement.append(
      card("No Achievements Earned", "This HTML did not match any achievement criteria.")
    );
    return;
  }
  for (const group of analysis.groups) {
    const section = document.createElement("section");
    section.className = "achievement-group";
    const heading = document.createElement("h2");
    heading.textContent = group.title;
    section.append(heading);
    const cards = document.createElement("div");
    cards.className = "achievement-cards";
    for (const achievement of group.earned) {
      cards.append(achievementCard(achievement));
    }
    section.append(cards);
    resultsElement.append(section);
  }
};
var achievementCard = (achievement) => {
  const container = document.createElement("article");
  container.className = "terminal-card";
  const header = document.createElement("header");
  header.className = achievement.hierarchy;
  header.textContent = achievement.title;
  const description = document.createElement("div");
  description.innerHTML = achievement.description;
  container.append(header, description);
  return container;
};
var card = (title, body) => {
  const container = document.createElement("article");
  container.className = "terminal-card";
  const header = document.createElement("header");
  header.textContent = title;
  const content = document.createElement("div");
  content.textContent = body;
  container.append(header, content);
  return container;
};
if (form !== null && input !== null && sampleButton !== null && clearButton !== null && summary !== null && results !== null) {
  sampleButton.addEventListener("click", () => {
    input.value = sampleHtml;
    renderAnalysis(input.value, summary, results);
  });
  clearButton.addEventListener("click", () => {
    input.value = "";
    renderEmptyState(summary, results);
    input.focus();
  });
  form.addEventListener("submit", (event) => {
    event.preventDefault();
    renderAnalysis(input.value, summary, results);
  });
  renderEmptyState(summary, results);
}
