import { spawn } from "node:child_process";
import fs from "node:fs";
import path from "node:path";

function exec(command, args = []) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, { stdio: "inherit" });
    child.on("close", (code) => {
      if (code !== 0) {
        reject(new Error(`"${command} ${args.join(" ")}" exited with code ${code}`));
      } else {
        resolve();
      }
    });
    child.on("error", reject);
  });
}

export async function prepare(config, context) {
  const versionFile = "./lib/ioprio/version.rb";
  const prev = fs.readFileSync(versionFile, { encoding: "UTF-8" });
  const next = prev.replace(
    /VERSION = ".+?"\.freeze/,
    `VERSION = "${context.nextRelease.version}".freeze`,
  );
  fs.writeFileSync(versionFile, next);
  await exec("bin/rake", ["build", "build:native"]);
}

export async function publish() {
  const gems = fs.readdirSync("./pkg").filter((f) => f.endsWith(".gem"));
  for (const gem of gems) {
    await exec("gem", ["push", path.join("pkg", gem)]);
  }
}
