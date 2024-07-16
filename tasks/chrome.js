#!/usr/bin/env node

const fs = require("node:fs/promises");
const os = require("node:os");
const path = require("node:path");

async function resetChromeSettings() {
  try {
    const filePath = path.join(
      os.homedir(),
      "snap/chromium/common/chromium/Default/Preferences",
    );
    const text = await fs.readFile(filePath, { encoding: "utf8" });
    const content = JSON.parse(text);

    const links = [
      {
        isMostVisited: true,
        title: "localhost:5173",
        url: "http://localhost:5173/",
      },
      {
        isMostVisited: true,
        title: "GitHub",
        url: "https://github.com/{{ cohort }}",
      },
      {
        title: "React",
        url: "https://react.dev/",
      },
      {
        isMostVisited: false,
        title: "Knex",
        url: "https://knexjs.org/",
      },
      {
        isMostVisited: true,
        title: "Discord",
        url: "https://discord.com/channels/@me",
      },
      {
        isMostVisited: false,
        title: "Testing Library",
        url: "https://testing-library.com/docs/",
      },
      {
        isMostVisited: false,
        title: "TS Cheatsheets",
        url: "https://www.typescriptlang.org/cheatsheets",
      },
    ];

    content.custom_links.list = links;

    content.browser.has_seen_welcome_page = true;
    content.browser.default_browser_infobar_last_declined = "14320388523920791";
    content.browser.should_reset_check_default_browser = false;
    content.signin.allowed = false;

    await fs.writeFile(filePath, JSON.stringify(content));
    console.log("DONE!");
    process.exitCode = 0;
  } catch (err) {
    process.exitCode = 1;
    console.log(err.message);
    if (err.message.includes("setting 'list'")) {
      console.log("\nCan't update preferences that do not exist.");
      console.log("Two options to fix this:");
      console.log("  - open chrome, check a new tab, close chrome");
      console.log(
        "  - set a bogus pin on the home page (will be replaced on success)",
      );
      console.log("Once completed, close chrome and run this script again.");
    }
  }
}

resetChromeSettings();
