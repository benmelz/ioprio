export default {
  branches: ["release"], // TODO: Switch back to main.
  plugins: [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    ["@semantic-release/github", { assets: [{ path: "pkg/*.gem" }] }],
  ],
};
