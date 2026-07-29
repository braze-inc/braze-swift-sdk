import UIKit

/// A row rendered as an editable text field with a trailing button, used by `ReadmeViewController`.
struct ReadmeTextFieldRow {
  let placeholder: String
  let buttonTitle: String
  let action: @MainActor (String, ReadmeViewController) -> Void
}

/// Text field rows displayed above the action rows. Populate before the window is created
/// (e.g. in `application(_:didFinishLaunchingWithOptions:)`).
@MainActor
var readmeTextFieldRows: [ReadmeTextFieldRow] = []
