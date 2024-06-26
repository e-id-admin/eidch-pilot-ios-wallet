import Danger
import Foundation

let pullRequestValidator = PullRequestValidator(danger: Danger())
pullRequestValidator.validate()

// MARK: - PullRequestValidator

// swiftlint:disable all
struct PullRequestValidator {

  // MARK: Lifecycle

  init(danger: DangerDSL) {
    self.danger = danger
  }

  // MARK: Internal

  let danger: DangerDSL

  func validate() {
    steps.forEach { $0() }
  }

  // MARK: Private

  private var steps: [() -> Void] {
    [
      validatePRSize,
      validateTitleLength,
      validateTitleContainsJiraNumber,
      validateDescriptionPresence,
      validateForCerFiles,
      finalizeMessage,
      performSwiftLint,
    ]
  }

  private func validatePRSize() {
    let additions = danger.github.pullRequest.additions!
    let deletions = danger.github.pullRequest.deletions!
    let numberOfLinesThreshold = 1000
    if additions + deletions > numberOfLinesThreshold {
      warn("PR size seems to exceed the normal size. 🙏 Please split this PR into multiple separate PRs to make the review process easier and faster.")
    }
  }

  private func validateTitleLength() {
    let title = danger.github.pullRequest.title
    let titleMinimumSize = 5
    if title.count < titleMinimumSize {
      fail("Title is too short. 🙏 Please provide a relevant title for your change request.")
    }
  }

  private func validateTitleContainsJiraNumber() {
    let title = danger.github.pullRequest.title
    let pattern = "EIDPERA-"
    if !title.contains(pattern) {
      fail("The title must contain the Jira ticket number in brackets: '(EIDPERA-XXX)', where XXX is a number. 🙏 Please adhere to the naming conventions.")
    }
  }

  private func validateDescriptionPresence() {
    if danger.github.pullRequest.body == nil || danger.github.pullRequest.body!.isEmpty {
      fail("PR has no description. 🙏 Please provide a detailed enough description to give context and information about your change request.")
    }
  }

  private func validateForCerFiles() {
    let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
    let cerFiles = editedFiles.filter { $0.hasSuffix(".cer") }
    if !cerFiles.isEmpty {
      fail("Certificates in PEM format, with an extension .cer, are not expected in this repo: \(cerFiles.joined(separator: ", ")). 🙏 Please convert it to a DER format (binary), with .der extension.")
    }
  }

  private func finalizeMessage() {
    let additions = danger.github.pullRequest.additions!
    let deletions = danger.github.pullRequest.deletions!
    let changedFiles = danger.github.pullRequest.changedFiles!
    message("🎉 The PR added \(additions) and removed \(deletions) lines. 🗂 \(changedFiles) files changed.")
  }

  private func performSwiftLint() {
    let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
    SwiftLint.lint(.files(editedFiles), inline: false, strict: true, quiet: false)
  }
}

// swiftlint:enable all
