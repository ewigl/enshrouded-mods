import { readFile, writeFile } from "fs";
import path from "path";
import { fileURLToPath } from "url";

// 解决 ES module 下没有 __dirname 的问题
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// JSON 文件路径
const jsonFilePath = path.join(
  __dirname,
  "..",
  "original",
  "localizations.json",
);
const outputFilePath = path.join(
  __dirname,
  "..",
  "original",
  "no_cn_items.json",
);

// 读取 JSON 文件
readFile(jsonFilePath, "utf8", (err, data) => {
  if (err) {
    console.error("读取文件出错:", err);
    return;
  }

  let fixesArray;
  try {
    fixesArray = JSON.parse(data);
  } catch (parseErr) {
    console.error("JSON 解析出错:", parseErr);
    return;
  }

  let no_translation_items = [];

  fixesArray.forEach((item) => {
    if (!item.cn) {
      no_translation_items.push(item);
    }
  });

  // console.log(no_translation_items);

  writeFile(
    outputFilePath,
    `${JSON.stringify(no_translation_items, null, 2)}\n`,
    "utf8",
    (writeErr) => {
      if (writeErr) {
        console.error("写入文件出错:", writeErr);
        return;
      }
      if (no_translation_items.length > 0) {
        console.log("未翻译项目已导出:", outputFilePath);
      } else {
        console.log("未发现未翻译项目");
      }
    },
  );
});
