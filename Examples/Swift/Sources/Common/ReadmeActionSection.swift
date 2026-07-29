import UIKit

/// An additional titled section of action rows, appended after the main "Actions" section.
struct ReadmeActionSection {
  let title: String
  let actions: [(String, String, @MainActor (ReadmeViewController) -> Void)]
}

/// Extra action sections displayed after the main "Actions" section. Populate before the window
/// is created (e.g. in `application(_:didFinishLaunchingWithOptions:)`).
@MainActor
var readmeActionSections: [ReadmeActionSection] = []
