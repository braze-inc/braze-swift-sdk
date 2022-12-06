#if UI_PREVIEWS

  import SwiftUI

  extension UIView {

    /// Wraps the UIView into a  `UIViewRepresentable` class for compatibility with SwiftUI previews.
    /// - Parameters:
    ///   - pin: The priority for pinning the view's edges to the container view (default: `nil`).
    ///   - center: The priority for centering the view in the container view (default: `nil`).
    ///   - flex: Allows the view to resize by setting the hugging and compression resistance
    ///           to low priorities (default: `false`).
    ///   - layout: A layout closure executed after the previous parameters have been applied.
    /// - Returns: A SwiftUI previews compatible view.
    @available(iOS 13.0, *)
    func preview(
      pin: UILayoutPriority? = nil,
      center: UILayoutPriority? = nil,
      flex: Bool = false,
      layout: @escaping (UIView) -> Void = { _ in }
    ) -> some View {

      class PreviewCoordinator {
        var setup = false
      }

      struct Wrapper: UIViewRepresentable {

        let view: UIView
        let pin: UILayoutPriority?
        let center: UILayoutPriority?
        let flex: Bool
        let layout: (UIView) -> Void

        init(
          view: UIView,
          pin: UILayoutPriority?,
          center: UILayoutPriority?,
          flex: Bool,
          layout: @escaping (UIView) -> Void
        ) {
          self.view = view
          self.pin = pin
          self.center = center
          self.flex = flex
          self.layout = layout
        }

        func updateUIView(_ view: UIView, context: Context) {
          guard !context.coordinator.setup else { return }
          context.coordinator.setup = true
          if let pin = pin {
            view.anchors.edges.pin().forEach { $0.priority = pin }
          }
          if let center = center {
            view.anchors.center.align().forEach { $0.priority = center }
          }
          let flexPriority: UILayoutPriority = flex ? .defaultLow : .required
          view.setContentHuggingPriority(flexPriority, for: .horizontal)
          view.setContentHuggingPriority(flexPriority, for: .vertical)
          view.setContentCompressionResistancePriority(flexPriority, for: .vertical)
          view.setContentCompressionResistancePriority(flexPriority, for: .horizontal)
          layout(view)
        }
        func makeUIView(context: Context) -> UIView {
          return view
        }

        func makeCoordinator() -> PreviewCoordinator {
          .init()
        }
      }

      return Wrapper(view: self, pin: pin, center: center, flex: flex, layout: layout)
        .previewLayout(.sizeThatFits)
    }

  }

  extension UIViewController {

    @available(iOS 13.0, *)
    func preview() -> some View {
      struct Wrapper: UIViewControllerRepresentable {
        typealias UIViewControllerType = UIViewController

        let viewController: UIViewController

        init(viewController: UIViewController) {
          self.viewController = viewController
        }

        func makeUIViewController(context: Context) -> UIViewController {
          viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

        }
      }
      return Wrapper(viewController: self)
        .edgesIgnoringSafeArea(.all)
    }

  }

#endif
