import BrazeKit
import Foundation

#if DEBUG

  // MARK: - Slideups

  extension Braze.InAppMessage.Slideup {

    public static let mock = Self(
      data: .mock,
      language: "en-US",
      message: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

    public static let mockText = Self(
      data: .mockNoClickAction,
      language: "en-US",
      message: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

    public static let mockShortText = Self(
      data: .mock,
      language: "en-US",
      message: "Short"
    )

    public static let mockChevron = Self(
      data: .mock,
      language: "en-US",
      message: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

    public static let mockIcon = Self(
      data: .mock,
      graphic: .icon(""),
      imageAltText: "slideup icon image alt text",
      language: "en-US",
      message: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

    public static let mockImage = Self(
      data: .mock,
      graphic: .image(.mockImage(width: 150, height: 150, textSize: 30)),
      imageAltText: "slideup image image alt text",
      language: "en-US",
      message: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

    public static let mockShort = Self(
      data: .init(),
      language: "en-US",
      message: "abc"
    )

    public static let mockLong = Self(
      data: .mock,
      graphic: .icon(""),
      imageAltText: "slideup long image alt text",
      language: "en-US",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon."
    )

    public static let mockThemed = Self(
      data: .mock,
      graphic: .icon(""),
      imageAltText: "slideup themed image alt text",
      language: "en-US",
      message: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake.",
      themes: [
        "light": .init(
          backgroundColor: 0xFF2D_3436,
          textColor: 0xFFE0_56FD,
          iconColor: 0xFF7F_FF00,
          iconBackgroundColor: 0xFF4B_6584,
          closeButtonColor: 0xFFE0_56FD
        )
      ]
    )

    public static let mockTop = Self(
      data: .mock,
      graphic: .icon(""),
      imageAltText: "slideup top image alt text",
      language: "en-US",
      message: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake.",
      slideFrom: .top
    )

  }

  // MARK: - Modals

  extension Braze.InAppMessage.Modal {

    public static let mock = Self(
      data: .mock,
      language: "en-US",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon."
    )

    public static let mockOneButton = Self(
      data: .mock,
      language: "en-US",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon.",
      buttons: [
        .mockPrimary
      ]
    )

    public static let mockTwoButtons = Self(
      data: .mock,
      language: "en-US",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon.",
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockIcon = Self(
      data: .mock,
      graphic: .icon(""),
      imageAltText: "modal icon image alt text",
      language: "en-US",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon.",
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockImage = Self(
      data: .mock,
      graphic: .image(.mockImage(width: 1450, height: 500)),
      imageAltText: "modal image image alt text",
      language: "en-US",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon.",
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockImageWrongAspectRatio = Self(
      data: .mock,
      graphic: .image(.mockImage(width: 1450, height: 650)),
      imageAltText: "modal image wrong aspect ratio image alt text",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon.",
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockLeadingAligned = Self(
      data: .mock,
      graphic: .icon(""),
      imageAltText: "modal leading aligned image alt text",
      language: "en-US",
      header: "Hello world!",
      headerTextAlignment: .leading,
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon.",
      messageTextAlignment: .leading,
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockLong = Self(
      data: .mock,
      graphic: .icon(""),
      imageAltText: "modal long image alt text",
      language: "en-US",
      header: "Hello world!",
      message:
        """
        Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon. Pie oat cake candy canes powder chocolate cupcake powder tart cupcake. Croissant halvah jujubes cotton candy biscuit tiramisu jujubes shortbread cheesecake. Sweet cupcake cupcake tart cake ice cream bear claw dragée cookie. Cake fruitcake donut macaroon gummi bears powder. Chocolate cake pie chupa chups fruitcake apple pie. Ice cream bonbon oat cake jelly-o biscuit sweet muffin. Caramels sweet danish chocolate wafer wafer cheesecake liquorice oat cake. Dessert shortbread donut pudding sesame snaps. Cookie powder chocolate bar cookie carrot cake pudding cake gummies cupcake.

        Jujubes bonbon bonbon lemon drops marzipan halvah carrot cake pastry. Donut chocolate bar chocolate cake halvah cake lollipop icing. Cake chupa chups carrot cake danish fruitcake. Chupa chups cake carrot cake dragée pastry. Dessert carrot cake macaroon chupa chups dragée carrot cake. Pudding sesame snaps toffee dragée carrot cake chupa chups sweet gummies. Soufflé croissant brownie dessert chupa chups tart brownie sugar plum. Tootsie roll danish dessert cake jelly cake tart tootsie roll marshmallow. Cookie ice cream danish muffin apple pie fruitcake sweet tart marshmallow. Dessert apple pie cotton candy biscuit muffin. Tiramisu candy candy cookie pastry. Brownie brownie cake jelly-o macaroon muffin oat cake donut.
        """,
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockTallCharacters = Self(
      data: .mock,
      graphic: .icon(""),
      imageAltText: "modal tall characters image alt text",
      language: "en-US",
      header: "헤더입니다",
      message:
        """
        제1항의 탄핵소추는 국회재적의원 3분의 1 이상의 발의가 있어야 하며, 그 의결은 국회재적의원 과반수의 찬성이 있어야 한다. 다만, 대통령에 대한 탄핵소추는 국회재적의원 과반수의 발의와 국회재적의원 3분의 2 이상의 찬성이 있어야 한다.
        국가는 건전한 소비행위를 계도하고 생산품의 품질향상을 촉구하기 위한 소비자보호운동을 법률이 정하는 바에 의하여 보장한다. 모든 국민은 능력에 따라 균등하게 교육을 받을 권리를 가진다.
        """
    )

    public static let mockThemed = Self(
      data: .mock,
      graphic: .icon(""),
      imageAltText: "modal themed image alt text",
      language: "en-US",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon.",
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ],
      themes: [
        "light": .init(
          backgroundColor: 0xFF2D_3436,
          textColor: 0xFFE0_56fD,
          iconColor: 0xFF7F_FF00,
          iconBackgroundColor: 0xFF4B_6584,
          headerTextColor: 0xFFE0_56fD,
          closeButtonColor: 0xFFE0_56fD
        )
      ]
    )

  }

  extension Braze.InAppMessage.ModalImage {

    public static let mock = Self(
      data: .mock,
      imageURL: .mockImage(width: 600, height: 600),
      imageAltText: "modal image image alt text",
      language: "en-US",
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockLargeImage = Self(
      data: .mock,
      imageURL: .mockImage(width: 1200, height: 2000),
      imageAltText: "modal image large image alt text",
      language: "en-US",
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockExtraLargeImage = Self(
      data: .mock,
      imageURL: .mockImage(width: 1200, height: 4000),
      imageAltText: "modal image extra large image alt text",
      language: "en-US",
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockNoButtons = Self(
      data: .mock,
      imageURL: .mockImage(width: 600, height: 600),
      imageAltText: "modal image no buttons image alt text",
      language: "en-US",
      buttons: []
    )

    public static let mockOneButton = Self(
      data: .mock,
      imageURL: .mockImage(width: 600, height: 600),
      imageAltText: "modal image one button image alt text",
      language: "en-US",
      buttons: [
        .mockPrimary
      ]
    )

    public static let mockThemed = Self(
      data: .mock,
      imageURL: .mockImage(width: 600, height: 600),
      imageAltText: "modal image themed image alt text",
      language: "en-US",
      buttons: [
        .mockSecondary,
        .mockPrimaryThemed,
      ],
      themes: [
        "light": .init(
          closeButtonColor: 0xFFC0_00FF,
          frameColor: 0xFF40_A0A0
        )
      ]
    )

  }

  // MARK: - Full

  extension Braze.InAppMessage.Full {

    public static let mock = Self(
      data: .mock,
      imageURL: .mockImage(width: 1200, height: 1000),
      imageAltText: "full image alt text",
      language: "en-US",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon."
    )

    public static let mockOneButton = Self(
      data: .mock,
      imageURL: .mockImage(width: 1200, height: 1000),
      imageAltText: "full one button image alt text",
      language: "en-US",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon.",
      buttons: [
        .mockPrimary
      ]
    )

    public static let mockTwoButtons = Self(
      data: .mock,
      imageURL: .mockImage(width: 1200, height: 1000),
      language: "en-US",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon.",
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockLandscape = Self(
      data: .mock,
      imageURL: .mockImage(width: 2000, height: 600),
      imageAltText: "full landscape image alt text",
      language: "en-US",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon."
    )

    public static let mockLandscapeOneButton = Self(
      data: .mock,
      imageURL: .mockImage(width: 2000, height: 600),
      imageAltText: "full landscape one button image alt text",
      language: "en-US",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon.",
      buttons: [.mockPrimary]
    )

    public static let mockLandscapeTwoButtons = Self(
      data: .mock,
      imageURL: .mockImage(width: 2000, height: 600),
      imageAltText: "full landscape two buttons image alt text",
      language: "en-US",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon.",
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockForcedLandscape = Self(
      data: .mockForcedLandscape,
      imageURL: .mockImage(width: 2000, height: 600),
      imageAltText: "full forced landscape image alt text",
      language: "en-US",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon."
    )

    public static let mockForcedPortrait = Self(
      data: .mockForcedPortrait,
      imageURL: .mockImage(width: 2000, height: 600),
      imageAltText: "full forced portrait image alt text",
      language: "en-US",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon."
    )

    public static let mockLeadingAligned = Self(
      data: .mock,
      imageURL: .mockImage(width: 1200, height: 1000),
      imageAltText: "full leading aligned image alt text",
      language: "en-US",
      header: "Hello world!",
      headerTextAlignment: .leading,
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon.",
      messageTextAlignment: .leading,
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockLong = Self(
      data: .mock,
      imageURL: .mockImage(width: 1200, height: 1000),
      imageAltText: "full long image alt text",
      language: "en-US",
      header: "Hello world!",
      message:
        """
        Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon. Pie oat cake candy canes powder chocolate cupcake powder tart cupcake. Croissant halvah jujubes cotton candy biscuit tiramisu jujubes shortbread cheesecake. Sweet cupcake cupcake tart cake ice cream bear claw dragée cookie. Cake fruitcake donut macaroon gummi bears powder. Chocolate cake pie chupa chups fruitcake apple pie. Ice cream bonbon oat cake jelly-o biscuit sweet muffin. Caramels sweet danish chocolate wafer wafer cheesecake liquorice oat cake. Dessert shortbread donut pudding sesame snaps. Cookie powder chocolate bar cookie carrot cake pudding cake gummies cupcake.

        Jujubes bonbon bonbon lemon drops marzipan halvah carrot cake pastry. Donut chocolate bar chocolate cake halvah cake lollipop icing. Cake chupa chups carrot cake danish fruitcake. Chupa chups cake carrot cake dragée pastry. Dessert carrot cake macaroon chupa chups dragée carrot cake. Pudding sesame snaps toffee dragée carrot cake chupa chups sweet gummies. Soufflé croissant brownie dessert chupa chups tart brownie sugar plum. Tootsie roll danish dessert cake jelly cake tart tootsie roll marshmallow. Cookie ice cream danish muffin apple pie fruitcake sweet tart marshmallow. Dessert apple pie cotton candy biscuit muffin. Tiramisu candy candy cookie pastry. Brownie brownie cake jelly-o macaroon muffin oat cake donut.
        """,
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockTallCharacters = Self(
      data: .mock,
      imageURL: .mockImage(width: 1200, height: 1000),
      imageAltText: "full tall characters image alt text",
      language: "en-US",
      header: "헤더입니다",
      message:
        """
        제1항의 탄핵소추는 국회재적의원 3분의 1 이상의 발의가 있어야 하며, 그 의결은 국회재적의원 과반수의 찬성이 있어야 한다. 다만, 대통령에 대한 탄핵소추는 국회재적의원 과반수의 발의와 국회재적의원 3분의 2 이상의 찬성이 있어야 한다.
        국가는 건전한 소비행위를 계도하고 생산품의 품질향상을 촉구하기 위한 소비자보호운동을 법률이 정하는 바에 의하여 보장한다. 모든 국민은 능력에 따라 균등하게 교육을 받을 권리를 가진다.
        """
    )

    public static let mockThemed = Self(
      data: .mock,
      imageURL: .mockImage(width: 1200, height: 1000),
      imageAltText: "full themed image alt text",
      language: "en-US",
      header: "Hello world!",
      message:
        "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon.",
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ],
      themes: [
        "light": .init(
          backgroundColor: 0xFF2D_3436,
          textColor: 0xFFE0_56fD,
          iconColor: 0xFF7F_FF00,
          iconBackgroundColor: 0xFF4B_6584,
          headerTextColor: 0xFFE0_56fD,
          closeButtonColor: 0xFFE0_56fD
        )
      ]
    )
  }

  extension Braze.InAppMessage.FullImage {

    public static let mock = Self(
      data: .mock,
      imageURL: .mockImage(width: 1200, height: 2000),
      imageAltText: "full image image alt text",
      language: "en-US"
    )

    public static let mockOneButton = Self(
      data: .mock,
      imageURL: .mockImage(width: 1200, height: 2000),
      imageAltText: "full one button image alt text",
      language: "en-US",
      buttons: [.mockPrimary]
    )

    public static let mockTwoButtons = Self(
      data: .mock,
      imageURL: .mockImage(width: 1200, height: 2000),
      imageAltText: "full two buttons image alt text",
      language: "en-US",
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockLandscape = Self(
      data: .mock,
      imageURL: .mockImage(width: 2000, height: 1200),
      imageAltText: "full landscape image alt text",
      language: "en-US"
    )

    public static let mockLandscapeOneButton = Self(
      data: .mock,
      imageURL: .mockImage(width: 2000, height: 1200),
      imageAltText: "full landscape one button image alt text",
      language: "en-US",
      buttons: [.mockPrimary]
    )

    public static let mockLandscapeTwoButtons = Self(
      data: .mock,
      imageURL: .mockImage(width: 2000, height: 1200),
      imageAltText: "full landscape two buttons image alt text",
      language: "en-US",
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockMinRecommendedSize = Self(
      data: .mock,
      imageURL: .mockImage(width: 600, height: 1000),
      imageAltText: "full min recommended size image alt text",
      language: "en-US",
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockRecommendedSize: Self = .mockTwoButtons

    public static let mockNonRecommendedSize = Self(
      data: .mock,
      imageURL: .mockImage(width: 1200, height: 4000),
      imageAltText: "full non recommended size image alt text",
      language: "en-US",
      buttons: [
        .mockSecondary,
        .mockPrimary,
      ]
    )

    public static let mockThemed = Self(
      data: .mock,
      imageURL: .mockImage(width: 1200, height: 2000),
      imageAltText: "full themed image alt text",
      language: "en-US",
      themes: [
        "light": .init(
          backgroundColor: 0xFF2D_3436,
          textColor: 0xFFE0_56FD,
          iconColor: 0xFF7F_FF00,
          iconBackgroundColor: 0xFF4B_6584,
          closeButtonColor: 0xFFE0_56FD
        )
      ]
    )

  }

  // MARK: - Buttons

  extension Braze.InAppMessage.Button {

    static let mockPrimary = Self(
      id: 1,
      text: "Yes please!",
      clickAction: .none,
      themes: ["light": .primary]
    )

    static let mockSecondary = Self(
      id: 0,
      text: "No thanks",
      clickAction: .none,
      themes: ["light": .secondary]
    )

    static let mockPrimaryThemed = Self(
      id: 0,
      text: "Yes please, but in purple!",
      clickAction: .none,
      themes: [
        "light": .init(
          textColor: 0xFFF0_80FF,
          borderColor: 0xFFFF_0080,
          backgroundColor: 0xFF40_0060
        )
      ]
    )

  }

  // MARK: - ClickAction

  extension Braze.InAppMessage.Data {

    public static let mock = Self(
      clickAction: .mock
    )

    public static let mockForcedLandscape = Self(
      orientation: .landscape
    )

    public static let mockForcedPortrait = Self(
      orientation: .portrait
    )

    public static let mockNoClickAction = Self()

  }

  extension Braze.InAppMessage.ClickAction {

    public static let mock = Self.url(URL(string: "https://example.com")!, useWebView: false)

  }

#endif
