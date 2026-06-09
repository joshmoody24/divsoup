import { analyzeHtml } from "./analyze";
import type { AchievementRule } from "./achievements";

const sampleHtml = `<!DOCTYPE html>
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

const form = document.querySelector<HTMLFormElement>("#analyze-form");
const input = document.querySelector<HTMLTextAreaElement>("#html-input");
const sampleButton = document.querySelector<HTMLButtonElement>("#load-sample");
const clearButton = document.querySelector<HTMLButtonElement>("#clear-input");
const summary = document.querySelector<HTMLElement>("#analysis-summary");
const results = document.querySelector<HTMLElement>("#analysis-results");

const renderEmptyState = (summaryElement: HTMLElement, resultsElement: HTMLElement): void => {
  summaryElement.textContent = "Paste HTML and run the analyzer.";
  resultsElement.replaceChildren();
};

const renderAnalysis = (
  rawHtml: string,
  summaryElement: HTMLElement,
  resultsElement: HTMLElement,
): void => {
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
      card("No Achievements Earned", "This HTML did not match any achievement criteria."),
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

const achievementCard = (achievement: AchievementRule): HTMLElement => {
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

const card = (title: string, body: string): HTMLElement => {
  const container = document.createElement("article");
  container.className = "terminal-card";

  const header = document.createElement("header");
  header.textContent = title;

  const content = document.createElement("div");
  content.textContent = body;

  container.append(header, content);
  return container;
};

if (
  form !== null &&
  input !== null &&
  sampleButton !== null &&
  clearButton !== null &&
  summary !== null &&
  results !== null
) {
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
