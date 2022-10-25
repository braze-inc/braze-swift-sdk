import BrazeKit

extension BrazeInAppMessageUI {

  public enum ViewAttributes {
    case slideup(SlideupView.Attributes)
    case modal(ModalView.Attributes)
    case modalImage(ModalImageView.Attributes)
    case full(FullView.Attributes)
    case fullImage(FullImageView.Attributes)
    case html(HtmlView.Attributes)

    public var slideup: SlideupView.Attributes? {
      get {
        guard case .slideup(let slideup) = self else { return nil }
        return slideup
      }
      set {
        guard let slideup = newValue, case .slideup = self else { return }
        self = .slideup(slideup)
      }
    }

    public var modal: ModalView.Attributes? {
      get {
        guard case .modal(let modal) = self else { return nil }
        return modal
      }
      set {
        guard let modal = newValue, case .modal = self else { return }
        self = .modal(modal)
      }
    }

    public var modalImage: ModalImageView.Attributes? {
      get {
        guard case .modalImage(let modalImage) = self else { return nil }
        return modalImage
      }
      set {
        guard let modalImage = newValue, case .modalImage = self else { return }
        self = .modalImage(modalImage)
      }
    }

    public var full: FullView.Attributes? {
      get {
        guard case .full(let full) = self else { return nil }
        return full
      }
      set {
        guard let full = newValue, case .full = self else { return }
        self = .full(full)
      }
    }

    public var fullImage: FullImageView.Attributes? {
      get {
        guard case .fullImage(let fullImage) = self else { return nil }
        return fullImage
      }
      set {
        guard let fullImage = newValue, case .fullImage = self else { return }
        self = .fullImage(fullImage)
      }
    }

    public var html: HtmlView.Attributes? {
      get {
        guard case .html(let html) = self else { return nil }
        return html
      }
      set {
        guard let html = newValue, case .html = self else { return }
        self = .html(html)
      }
    }

    public static func defaults(for message: Braze.InAppMessage) -> Self? {
      switch message {
      case .slideup:
        return .slideup(.defaults)
      case .modal:
        return .modal(.defaults)
      case .modalImage:
        return .modalImage(.defaults)
      case .full:
        return .full(.defaults)
      case .fullImage:
        return .fullImage(.defaults)
      case .html:
        return .html(.defaults)
      case .control:
        return nil
      @unknown default:
        return nil
      }
    }
  }

}
