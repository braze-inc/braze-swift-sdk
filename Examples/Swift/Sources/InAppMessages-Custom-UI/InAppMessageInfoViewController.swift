import BrazeKit
import UIKit

final class InAppMessageInfoViewController: UITableViewController {

  // Represents an in-app message property
  struct Field {
    let name: String
    var value: Any
    var indentation: Int = 0
  }

  // Represents a table view section
  struct Section {
    let name: String?
    var fields: [Field]
  }

  // MARK: - Properties

  let sections: [Section]

  // MARK: - Initialization

  init(message: Braze.InAppMessage) {
    sections = Self.messageSections(from: message) + Self.dataSections(from: message)
    super.init(style: .grouped)
    title = "In-App Message Info"
    let doneButton = UIBarButtonItem(
      barButtonSystemItem: .done, target: self, action: #selector(dismissModal))
    navigationItem.setRightBarButton(doneButton, animated: false)

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44.0
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - LifeCycle

  @objc
  func dismissModal() {
    dismiss(animated: true)
  }

  // MARK: - UITableViewDataSource

  override func numberOfSections(in tableView: UITableView) -> Int {
    sections.count
  }

  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    sections[section].fields.count
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell =
      tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")
      ?? UITableViewCell(style: .value1, reuseIdentifier: "cellIdentifier")

    let field = sections[indexPath.section].fields[indexPath.row]
    cell.textLabel?.text = field.name
    cell.detailTextLabel?.text = "\(field.value)"
    cell.indentationLevel = field.indentation

    cell.textLabel?.numberOfLines = 0
    if #available(iOS 13.0, tvOS 13.0, *) {
      cell.textLabel?.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
      cell.detailTextLabel?.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
    }

    return cell
  }

  override func tableView(
    _ tableView: UITableView,
    titleForHeaderInSection section: Int
  ) -> String? {
    sections[section].name
  }

  // MARK: - Helpers

  /// The message specific sections (e.g. Slideup data, Modal data)
  static func messageSections(from message: Braze.InAppMessage) -> [Section] {
    var section = Section(name: "Message", fields: [])
    var buttonsSection: Section?
    var themesSection: Section?
    switch message {
    case .slideup(let slideup):
      section.fields =
        [
          Field(name: "type", value: "slideup"),
          Field(name: "message", value: slideup.message, indentation: 1),
          Field(name: "slideFrom", value: slideup.slideFrom.rawValue, indentation: 1),
        ] + fields(from: slideup.graphic, indentation: 1)
      themesSection = self.themesSection(from: slideup.themes)
    case .modal(let modal):
      section.fields =
        [
          Field(name: "type", value: "modal"),
          Field(name: "header", value: modal.header, indentation: 1),
          Field(name: "message", value: modal.message, indentation: 1),
          Field(
            name: "headerTextAlignment", value: modal.headerTextAlignment.rawValue, indentation: 1),
          Field(
            name: "messageTextAlignment", value: modal.messageTextAlignment.rawValue, indentation: 1
          ),
        ] + fields(from: modal.graphic, indentation: 1)
      buttonsSection = self.buttonsSection(from: modal.buttons)
      themesSection = self.themesSection(from: modal.themes)
    case .modalImage(let modalImage):
      section.fields = [
        Field(name: "type", value: "modalImage"),
        Field(name: "imageURL", value: modalImage.imageURL, indentation: 1),
      ]
      buttonsSection = self.buttonsSection(from: modalImage.buttons)
      themesSection = self.themesSection(from: modalImage.themes)
    case .full(let full):
      section.fields = [
        Field(name: "type", value: "full"),
        Field(name: "imageURL", value: full.imageURL, indentation: 1),
        Field(name: "header", value: full.header, indentation: 1),
        Field(name: "message", value: full.message, indentation: 1),
        Field(name: "headerTextAlignment", value: full.headerTextAlignment, indentation: 1),
        Field(name: "messageTextAlignment", value: full.messageTextAlignment, indentation: 1),
      ]
      buttonsSection = self.buttonsSection(from: full.buttons)
      themesSection = self.themesSection(from: full.themes)
    case .fullImage(let fullImage):
      section.fields = [
        Field(name: "type", value: "fullImage"),
        Field(name: "imageURL", value: fullImage.imageURL, indentation: 1),
      ]
      buttonsSection = self.buttonsSection(from: fullImage.buttons)
      themesSection = self.themesSection(from: fullImage.themes)
    case .html(let html):
      section.fields = [
        Field(name: "type", value: "html"),
        Field(name: "message", value: "", indentation: 1),
        Field(name: html.message, value: "", indentation: 2),
        Field(name: "baseURL", value: "", indentation: 1),
        Field(name: html.baseURL?.absoluteString ?? "none", value: "", indentation: 2),
        Field(name: "assetURLs", value: "", indentation: 1),
        Field(name: html.assetURLs.prettyPrint(), value: "", indentation: 2),
        Field(name: "legacy", value: html.legacy, indentation: 1),
      ]
    case .control:
      section.fields = [
        Field(name: "type", value: "control")
      ]
    @unknown default:
      break
    }

    return [section, buttonsSection, themesSection].compactMap { $0 }
  }

  /// The themes section.
  static func themesSection(from themes: Braze.InAppMessage.Themes) -> Section {
    var section = Section(name: "Themes", fields: [])

    for (name, theme) in themes.themes {
      section.fields += [
        Field(name: "theme", value: name),
        Field(name: "textColor", value: theme.textColor.hexString, indentation: 1),
        Field(name: "headerTextColor", value: theme.headerTextColor.hexString, indentation: 1),
        Field(name: "closeButtonColor", value: theme.closeButtonColor.hexString, indentation: 1),
        Field(name: "iconColor", value: theme.iconColor.hexString, indentation: 1),
        Field(
          name: "iconBackgroundColor", value: theme.iconBackgroundColor.hexString, indentation: 1),
        Field(name: "backgroundColor", value: theme.backgroundColor.hexString, indentation: 1),
        Field(name: "frameColor", value: theme.frameColor.hexString, indentation: 1),
      ]
    }

    return section
  }

  /// The buttons section.
  static func buttonsSection(from buttons: [Braze.InAppMessage.Button]) -> Section? {
    if buttons.isEmpty { return nil }
    var section = Section(name: "Buttons", fields: [])

    for button in buttons {
      section.fields += [
        Field(name: "button", value: button.id),
        Field(name: "text", value: button.text, indentation: 1),
      ]
      section.fields += fields(from: button.clickAction)
      section.fields += fields(from: button.themes)
    }

    return section
  }

  /// The fields common to all in-app messages.
  static func dataSections(from message: Braze.InAppMessage) -> [Section] {
    var section = Section(name: "Data", fields: [])

    // Click Action
    section.fields += fields(from: message.clickAction)

    // Message Close
    section.fields += fields(from: message.messageClose)

    // Orientation
    section.fields += [Field(name: "orientation", value: message.orientation)]

    // Animation
    section.fields += [
      Field(name: "animateIn", value: message.animateIn),
      Field(name: "animateOut", value: message.animateOut),
    ]

    // Extras
    section.fields += [
      Field(name: "extras", value: ""),
      Field(name: message.extras.prettyPrint(), value: "", indentation: 1),
    ]

    return [section]
  }

  /// The fields for a ClickAction value
  static func fields(
    from clickAction: Braze.InAppMessage.ClickAction,
    indentation: Int = 0
  ) -> [Field] {
    var fields: [Field] = []

    // Click Action
    var header = Field(name: "clickAction", value: "", indentation: indentation)
    switch clickAction {
    case .none:
      header.value = "none"
    case .newsFeed:
      header.value = "newsFeed"
    case .url(let url, let useWebView):
      header.value = "url"
      fields = [
        Field(name: "url", value: url, indentation: indentation + 1),
        Field(name: "useWebView", value: useWebView, indentation: indentation + 1),
      ]
    @unknown default:
      break
    }

    return [header] + fields
  }

  /// The fields for a MessageClose value
  static func fields(
    from messageClose: Braze.InAppMessage.MessageClose,
    indentation: Int = 0
  ) -> [Field] {
    var fields: [Field] = []

    // Message Close
    var header = Field(name: "messageClose", value: "", indentation: indentation)
    switch messageClose {
    case .userInteraction:
      header.value = "userInteraction"
    case .auto(let interval):
      header.value = "auto"
      fields = [Field(name: "interval", value: interval, indentation: indentation + 1)]
    @unknown default:
      break
    }

    return [header] + fields
  }

  /// The fields for a Graphic value.
  static func fields(
    from graphic: Braze.InAppMessage.Graphic?,
    indentation: Int = 0
  ) -> [Field] {
    var fields: [Field] = []

    var header = Field(name: "graphic", value: "", indentation: indentation)
    switch graphic {
    case .none:
      header.value = "none"
    case .icon(let icon):
      header.value = "icon"
      fields = [
        Field(
          name: "icon (FontAwesome, may not render correctly here)", value: icon,
          indentation: indentation + 1)
      ]
    case .image(let url):
      header.value = "image"
      fields = [Field(name: "image url", value: url, indentation: indentation + 1)]
    @unknown default:
      break
    }
    return [header] + fields
  }

  /// The fields for a ButtonThemes value
  static func fields(
    from buttonThemes: Braze.InAppMessage.ButtonThemes,
    indentation: Int = 0
  ) -> [Field] {
    var fields: [Field] = []

    for (name, theme) in buttonThemes.themes {
      fields += [
        Field(name: "theme", value: name, indentation: indentation),
        Field(name: "textColor", value: theme.textColor.hexString, indentation: indentation + 1),
        Field(
          name: "backgroundColor", value: theme.backgroundColor.hexString,
          indentation: indentation + 1),
        Field(
          name: "borderColor", value: theme.borderColor.hexString, indentation: indentation + 1),
      ]
    }

    return fields
  }

}
