import { mkdir, writeFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { rules } from "./achievements";
import { sortAchievements, titleizeGroup } from "./analyze";
import type { AchievementRule } from "./achievements";

interface AchievementGroup {
  group: string;
  title: string;
  achievements: AchievementRule[];
}

const pagePath = join(process.cwd(), "static_html", "achievements.html");

const groupedAchievements = (): AchievementGroup[] =>
  Array.from(
    rules
      .reduce<Map<string, AchievementRule[]>>((groups, rule) => {
        const existingRules = groups.get(rule.group) ?? [];
        return new Map(groups).set(rule.group, [...existingRules, rule]);
      }, new Map())
      .entries(),
  ).map(([group, achievements]) => ({
    group,
    title: titleizeGroup(group),
    achievements: sortAchievements(achievements),
  }));

const escapeHtml = (value: string): string =>
  value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");

const renderAchievementCard = (achievement: AchievementRule): string => `
                <div class="terminal-card">
                  <header class="${escapeHtml(achievement.hierarchy)}">${escapeHtml(
                    achievement.title,
                  )}</header>
                  <div>${achievement.description}</div>
                </div>`;

const renderAchievementGroup = (group: AchievementGroup): string => `
            <section class="achievement-group" id="${escapeHtml(group.group)}">
              <h2>${escapeHtml(group.title)}</h2>
              <div class="achievement-cards">
${group.achievements.map(renderAchievementCard).join("\n")}
              </div>
            </section>`;

const renderPage = (groups: AchievementGroup[]): string => `<!doctype html>
<html lang="en" class="[scrollbar-gutter:stable]">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title data-default="divsoup">Achievements | divsoup</title>
    <link rel="stylesheet" href="./achievements_files/app-5b4a0bc89cc3e87ff5b7ee31104fab49.css" />
    <link
      rel="stylesheet"
      href="./achievements_files/achievements-ca96fae6572ee42a12b49e35392041f0.css"
    />
  </head>
  <body class="terminal">
    <style>
      :root {
        --global-font-size: 15px;
        --global-line-height: 1.4em;
        --global-space: 10px;
        --font-stack:
          Menlo, Monaco, Lucida Console, Liberation Mono, DejaVu Sans Mono,
          Bitstream Vera Sans Mono, Courier New, monospace, serif;
        --mono-font-stack:
          Menlo, Monaco, Lucida Console, Liberation Mono, DejaVu Sans Mono,
          Bitstream Vera Sans Mono, Courier New, monospace, serif;
        --background-color: #222225;
        --page-width: 60em;
        --font-color: #e8e9ed;
        --invert-font-color: #222225;
        --secondary-color: #a3abba;
        --tertiary-color: #a3abba;
        --primary-color: #62c4ff;
        --error-color: #ff3c74;
        --progress-bar-background: #3f3f44;
        --progress-bar-fill: #62c4ff;
        --code-bg-color: #3f3f44;
        --input-style: solid;
        --display-h1-decoration: none;
      }

      html,
      body {
        height: 100%;
        margin: 0;
      }

      .container {
        min-height: 100%;
        display: flex;
        flex-direction: column;
      }

      main {
        flex: 1;
        padding-top: 30px;
      }

      .footer-content {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 100%;
      }

      .footer-content p {
        margin: 0;
      }

      .footer-links a {
        color: var(--primary-color);
        text-decoration: none;
      }

      .footer-links a:hover {
        text-decoration: underline;
      }

      .terminal-card ul {
        padding: 0;
        margin: 0;
      }

      .terminal-card {
        margin-bottom: var(--global-line-height);
      }

      footer {
        margin-top: auto;
        padding-top: 0;
        padding-bottom: 20px;
      }

      footer hr {
        margin-bottom: 20px;
      }
    </style>
    <div class="container">
      <nav class="terminal-nav">
        <div class="terminal-logo">
          <div class="logo terminal-prompt"><a href="index.html" class="no-style">divsoup</a></div>
        </div>
        <nav class="terminal-menu">
          <ul>
            <li><a href="index.html">Home</a></li>
            <li><a href="achievements.html">Achievements</a></li>
            <li><a href="about.html">About</a></li>
          </ul>
        </nav>
      </nav>

      <main>
        <div class="achievements-page">
          <h1>All Achievements</h1>
          <p>Below is a list of all possible achievements.</p>

          <div class="achievements-container">
${groups.map(renderAchievementGroup).join("\n")}
          </div>

          <div class="back-link">
            <a href="index.html">Back to Home</a>
          </div>
        </div>
      </main>

      <footer>
        <hr />
        <div class="footer-content">
          <div class="footer-links">
            <p>
              © 2025 <a href="https://joshmoody.org/" target="_blank">Josh Moody</a> |
              <a href="https://github.com/joshmoody24/" target="_blank">GitHub</a>
            </p>
          </div>
        </div>
      </footer>
    </div>
  </body>
</html>
`;

await mkdir(dirname(pagePath), { recursive: true });
await writeFile(pagePath, renderPage(groupedAchievements()));
