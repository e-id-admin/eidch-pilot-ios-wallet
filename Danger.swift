import Danger
import Foundation

let danger = Danger()

let numberOfLinesThreshold = 1000
let titleMinimumSize = 5

// swiftlint:disable all
let additions = danger.github.pullRequest.additions!
let deletions = danger.github.pullRequest.deletions!
let changedFiles = danger.github.pullRequest.changedFiles!
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles

if additions + deletions > numberOfLinesThreshold {
  warn("PR size seems to exceed the normal size. Split this PR into multiple separate PR will helps faster and easier review process.")
}

// Title validation
let title = danger.github.pullRequest.title
if title.count < titleMinimumSize {
  fail("Title is too short. 🙏 Please check the given guideline for formatting your PRs.")
}

if danger.github.pullRequest.body == nil || danger.github.pullRequest.body!.isEmpty {
  fail("PR has no description... Provide a detailed enough description to give context and informations (such as changes, ideas and so on) about your PR.")
}

message("🎉 The PR added \(additions) and removed \(deletions) lines. 🗂 \(changedFiles) files changed.")

SwiftLint.lint(.files(editedFiles), inline: false, strict: true, quiet: false)
// swiftlint:enable all
