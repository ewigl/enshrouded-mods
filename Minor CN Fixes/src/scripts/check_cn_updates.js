const fs = require("fs");
const path = require("path");

const root = __dirname;
const localizationsFile = path.join(
  root,
  "..",
  "original",
  "localizations.json",
);
const fixesFile = path.join(root, "..", "tags", "mistranslation_tags.json");
const outputFile = path.join(root, "..", "original", "to_be_update.json");

function load(file) {
  try {
    return JSON.parse(fs.readFileSync(file, "utf8"));
  } catch (error) {
    throw new Error(`读取 ${file} 失败：${error.message}`);
  }
}

const latest = new Map(load(localizationsFile).map((item) => [item.id, item]));
const old = new Map(load(fixesFile).map((item) => [item.id, item]));
const updates = [];

for (const [id, oldItem] of old) {
  const latestItem = latest.get(id);

  if (latestItem?.cn !== oldItem?.cn) {
    updates.push({
      id,
      en: latestItem?.en ?? oldItem?.en ?? null,
      cn: latestItem?.cn ?? null,
      cn_old: oldItem?.cn ?? null,
    });
  }
}

if (updates.length) {
  fs.writeFileSync(outputFile, `${JSON.stringify(updates, null, 2)}\n`, "utf8");
  console.log(`发现 ${updates.length} 个不同项目，已导出到 ${outputFile}`);
} else {
  fs.writeFileSync(outputFile, `${JSON.stringify(updates, null, 2)}\n`, "utf8");
  console.log("未发现更新项目");
}
