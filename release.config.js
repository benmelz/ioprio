export default {
  branches: ["main"],
  plugins: [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "./.release/gem.js",
    ["@semantic-release/github", { assets: [{ path: "pkg/*.gem" }] }],
  ],
};
