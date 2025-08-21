import BrazeKit
import Foundation
import UIKit

#if DEBUG

  // MARK: - Classic

  extension Braze.ContentCard.Classic {

    public static let mockPinned = Self(
      data: .init(viewed: true, pinned: true),
      language: "en-US",
      title: "Pinned",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

    public static let mockUnviewed = Self(
      data: .init(),
      language: "en-US",
      title: "Unviewed",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

    public static let mockViewed = Self(
      data: .init(viewed: true),
      language: "en-US",
      title: "Viewed",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

    public static let mockDomain = Self(
      data: .init(viewed: true),
      language: "en-US",
      title: "Domain",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake.",
      domain: "domain.com"
    )

    public static let mockShort = Self(
      data: .init(viewed: true),
      language: "en-US",
      title: "Short Text",
      description: "abc"
    )

    public static let mockLong = Self(
      data: .init(viewed: true),
      language: "en-US",
      title:
        "Long Text | Cupcake ipsum dolor sit amet cake brownie powder. Pudding chupa chups toffee liquorice biscuit pastry dragée marshmallow bonbon. Gummi bears liquorice gingerbread donut pudding liquorice.",
      description:
        """
        Cupcake ipsum dolor sit amet cake brownie powder. Pudding chupa chups toffee liquorice biscuit pastry dragée marshmallow bonbon. Gummi bears liquorice gingerbread donut pudding liquorice.

        Tiramisu bear claw icing chocolate cake brownie halvah caramels. Pastry tiramisu toffee cookie gummies carrot cake candy canes fruitcake. Pastry marshmallow cake sweet roll cake muffin.

        Tootsie roll pudding danish brownie topping bonbon tart. Dragée gingerbread lollipop toffee candy jujubes. Wafer gummi bears jelly-o soufflé cake cheesecake apple pie caramels chupa chups. Wafer jelly beans jelly-o caramels chocolate cake chocolate cake cake candy.
        """
    )

    public static let mockExtraLong = Self(
      data: .init(viewed: true),
      language: "en-US",
      title:
        "Extra Long Text | Cupcake ipsum dolor sit amet carrot cake tootsie roll jujubes. Powder tiramisu jelly beans cake bear claw chocolate oat cake cotton candy tart. Jelly lemon drops brownie chocolate bar brownie cotton candy. Brownie chupa chups jelly halvah jelly beans shortbread soufflé. Cheesecake oat cake oat cake apple pie cheesecake candy canes jelly-o. Candy canes cupcake muffin cotton candy lollipop pudding. Icing jelly-o shortbread icing icing. Jelly-o lollipop lemon drops cake tiramisu cheesecake. Croissant gummi bears powder gingerbread cotton candy.",
      description:
        """
        Cupcake ipsum dolor sit amet carrot cake tootsie roll jujubes. Powder tiramisu jelly beans cake bear claw chocolate oat cake cotton candy tart. Jelly lemon drops brownie chocolate bar brownie cotton candy. Brownie chupa chups jelly halvah jelly beans shortbread soufflé. Cheesecake oat cake oat cake apple pie cheesecake candy canes jelly-o. Candy canes cupcake muffin cotton candy lollipop pudding. Icing jelly-o shortbread icing icing. Jelly-o lollipop lemon drops cake tiramisu cheesecake. Croissant gummi bears powder gingerbread cotton candy.

        Halvah halvah lollipop cookie ice cream brownie macaroon shortbread. Pie sesame snaps chocolate chocolate cake cupcake danish. Jelly beans lemon drops icing tootsie roll marzipan croissant soufflé soufflé. Chupa chups marzipan apple pie pastry gingerbread. Jelly beans oat cake cotton candy chupa chups topping chocolate bar liquorice. Topping tiramisu lollipop gingerbread cake icing lemon drops candy canes sweet. Danish marzipan marshmallow cake pudding chocolate cake lollipop cake marshmallow. Chocolate fruitcake halvah oat cake tart powder cupcake marshmallow marshmallow.

        Brownie tootsie roll candy canes sweet bonbon. Gingerbread sugar plum sweet tart jelly-o. Sesame snaps tootsie roll soufflé lollipop jelly sugar plum halvah pastry wafer. Pie halvah tiramisu lemon drops jelly apple pie. Pastry shortbread carrot cake oat cake shortbread lollipop. Pudding sweet roll fruitcake marzipan halvah.

        Chocolate bar marshmallow bonbon cake cheesecake chocolate bar dessert muffin. Sugar plum dragée sesame snaps bear claw jelly fruitcake. Powder lollipop cupcake wafer marzipan donut pudding jujubes fruitcake. Gingerbread dragée dessert chupa chups cheesecake tart. Chocolate bar pudding cake cookie gummi bears icing. Wafer apple pie icing sesame snaps candy. Marzipan muffin icing marzipan cupcake bear claw cake. Caramels oat cake tiramisu cake candy jelly. Apple pie ice cream caramels candy canes carrot cake candy bear claw. Brownie sweet roll oat cake icing bear claw wafer.

        Sweet roll cookie jelly-o soufflé sugar plum bear claw dragée candy canes gummies. Cake carrot cake brownie donut chocolate gummies brownie cotton candy. Lollipop biscuit candy halvah chocolate cake biscuit sweet. Chocolate bar danish gummies pastry icing. Carrot cake pudding jujubes dragée toffee fruitcake toffee. Gingerbread caramels chupa chups jelly-o jujubes cookie sesame snaps.
        """
    )
  }

  // MARK: - ClassicImage

  extension Braze.ContentCard.ClassicImage {

    public static let mockPinned = Self(
      data: .init(viewed: true, pinned: true),
      image: .mockImage(width: 100, height: 100, text: "100", textSize: 20),
      imageAltText: "Pinned classic image card",
      language: "en-US",
      title: "Pinned",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

    public static let mockUnviewed = Self(
      data: .init(),
      image: .mockImage(width: 100, height: 100, text: "100", textSize: 20),
      imageAltText: "Unviewed classic image card",
      language: "en-US",
      title: "Unviewed",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

    public static let mockViewed = Self(
      data: .init(viewed: true),
      image: .mockImage(width: 100, height: 100, text: "100", textSize: 20),
      imageAltText: "Viewed classic image card",
      language: "en-US",
      title: "Viewed",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

    public static let mockDomain = Self(
      data: .init(viewed: true),
      image: .mockImage(width: 100, height: 100, text: "100", textSize: 20),
      imageAltText: "Domain classic image card",
      language: "en-US",
      title: "Domain",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake.",
      domain: "domain.com"
    )

    public static let mockShort = Self(
      data: .init(viewed: true),
      image: .mockImage(width: 100, height: 100, text: "100", textSize: 20),
      imageAltText: "Short classic image card",
      language: "en-US",
      title: "Short Text",
      description: "abc"
    )

    public static let mockLong = Self(
      data: .init(viewed: true),
      image: .mockImage(width: 100, height: 100, text: "100", textSize: 20),
      imageAltText: "Long classic image card",
      language: "en-US",
      title:
        "Long Text | Cupcake ipsum dolor sit amet cake brownie powder. Pudding chupa chups toffee liquorice biscuit pastry dragée marshmallow bonbon. Gummi bears liquorice gingerbread donut pudding liquorice.",
      description:
        """
        Cupcake ipsum dolor sit amet cake brownie powder. Pudding chupa chups toffee liquorice biscuit pastry dragée marshmallow bonbon. Gummi bears liquorice gingerbread donut pudding liquorice.

        Tiramisu bear claw icing chocolate cake brownie halvah caramels. Pastry tiramisu toffee cookie gummies carrot cake candy canes fruitcake. Pastry marshmallow cake sweet roll cake muffin.

        Tootsie roll pudding danish brownie topping bonbon tart. Dragée gingerbread lollipop toffee candy jujubes. Wafer gummi bears jelly-o soufflé cake cheesecake apple pie caramels chupa chups. Wafer jelly beans jelly-o caramels chocolate cake chocolate cake cake candy.
        """
    )

    public static let mockExtraLong = Self(
      data: .init(viewed: true),
      image: .mockImage(width: 100, height: 100, text: "100", textSize: 20),
      imageAltText: "Extra long classic image card",
      language: "en-US",
      title:
        "Extra Long Text | Cupcake ipsum dolor sit amet carrot cake tootsie roll jujubes. Powder tiramisu jelly beans cake bear claw chocolate oat cake cotton candy tart. Jelly lemon drops brownie chocolate bar brownie cotton candy. Brownie chupa chups jelly halvah jelly beans shortbread soufflé. Cheesecake oat cake oat cake apple pie cheesecake candy canes jelly-o. Candy canes cupcake muffin cotton candy lollipop pudding. Icing jelly-o shortbread icing icing. Jelly-o lollipop lemon drops cake tiramisu cheesecake. Croissant gummi bears powder gingerbread cotton candy.",
      description:
        """
        Cupcake ipsum dolor sit amet carrot cake tootsie roll jujubes. Powder tiramisu jelly beans cake bear claw chocolate oat cake cotton candy tart. Jelly lemon drops brownie chocolate bar brownie cotton candy. Brownie chupa chups jelly halvah jelly beans shortbread soufflé. Cheesecake oat cake oat cake apple pie cheesecake candy canes jelly-o. Candy canes cupcake muffin cotton candy lollipop pudding. Icing jelly-o shortbread icing icing. Jelly-o lollipop lemon drops cake tiramisu cheesecake. Croissant gummi bears powder gingerbread cotton candy.

        Halvah halvah lollipop cookie ice cream brownie macaroon shortbread. Pie sesame snaps chocolate chocolate cake cupcake danish. Jelly beans lemon drops icing tootsie roll marzipan croissant soufflé soufflé. Chupa chups marzipan apple pie pastry gingerbread. Jelly beans oat cake cotton candy chupa chups topping chocolate bar liquorice. Topping tiramisu lollipop gingerbread cake icing lemon drops candy canes sweet. Danish marzipan marshmallow cake pudding chocolate cake lollipop cake marshmallow. Chocolate fruitcake halvah oat cake tart powder cupcake marshmallow marshmallow.

        Brownie tootsie roll candy canes sweet bonbon. Gingerbread sugar plum sweet tart jelly-o. Sesame snaps tootsie roll soufflé lollipop jelly sugar plum halvah pastry wafer. Pie halvah tiramisu lemon drops jelly apple pie. Pastry shortbread carrot cake oat cake shortbread lollipop. Pudding sweet roll fruitcake marzipan halvah.

        Chocolate bar marshmallow bonbon cake cheesecake chocolate bar dessert muffin. Sugar plum dragée sesame snaps bear claw jelly fruitcake. Powder lollipop cupcake wafer marzipan donut pudding jujubes fruitcake. Gingerbread dragée dessert chupa chups cheesecake tart. Chocolate bar pudding cake cookie gummi bears icing. Wafer apple pie icing sesame snaps candy. Marzipan muffin icing marzipan cupcake bear claw cake. Caramels oat cake tiramisu cake candy jelly. Apple pie ice cream caramels candy canes carrot cake candy bear claw. Brownie sweet roll oat cake icing bear claw wafer.

        Sweet roll cookie jelly-o soufflé sugar plum bear claw dragée candy canes gummies. Cake carrot cake brownie donut chocolate gummies brownie cotton candy. Lollipop biscuit candy halvah chocolate cake biscuit sweet. Chocolate bar danish gummies pastry icing. Carrot cake pudding jujubes dragée toffee fruitcake toffee. Gingerbread caramels chupa chups jelly-o jujubes cookie sesame snaps.
        """
    )

    public static let mockEmptyAltText = Self(
      data: .init(viewed: true),
      image: .mockImage(width: 100, height: 100, text: "100", textSize: 20),
      imageAltText: "",
      language: "en-US",
      title: "Empty Alt Text",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

  }

  // MARK: - ImageOnly

  extension Braze.ContentCard.ImageOnly {

    private static let backgroundColor = UIColor(red: 0.38, green: 0.64, blue: 0.74, alpha: 1.00)

    public static let mockPinned = Self(
      data: .init(viewed: true, pinned: true),
      image: .mockImage(
        width: 400,
        height: 200,
        text: "Pinned",
        backgroundColor: backgroundColor
      ),
      imageAltText: "Pinned image only card",
      language: "en-US"
    )

    public static let mockUnviewed = Self(
      data: .init(),
      image: .mockImage(
        width: 400,
        height: 200,
        text: "Unviewed",
        backgroundColor: backgroundColor
      ),
      imageAltText: "Unviewed image only card",
      language: "en-US"
    )

    public static let mockViewed = Self(
      data: .init(viewed: true),
      image: .mockImage(
        width: 400,
        height: 200,
        text: "Viewed",
        backgroundColor: backgroundColor
      ),
      imageAltText: "Viewed image only card",
      language: "en-US"
    )

    public static let mockEmptyAltText = Self(
      data: .init(viewed: true),
      image: .mockImage(
        width: 400,
        height: 200,
        text: "Empty Alt",
        backgroundColor: backgroundColor
      ),
      imageAltText: "",
      language: "en-US"
    )

  }

  // MARK: - CaptionedImage

  extension Braze.ContentCard.CaptionedImage {

    private static let backgroundColor = UIColor(red: 0.38, green: 0.64, blue: 0.74, alpha: 1.00)

    public static let mockPinned = Self(
      data: .init(viewed: true, pinned: true),
      image: .mockImage(width: 600, height: 400, backgroundColor: backgroundColor),
      imageAltText: "Pinned captioned image card",
      language: "en-US",
      title: "Pinned",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

    public static let mockUnviewed = Self(
      data: .init(),
      image: .mockImage(width: 600, height: 400, backgroundColor: backgroundColor),
      imageAltText: "Unviewed captioned image card",
      language: "en-US",
      title: "Unviewed",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

    public static let mockViewed = Self(
      data: .init(viewed: true),
      image: .mockImage(width: 600, height: 400, backgroundColor: backgroundColor),
      imageAltText: "Viewed captioned image card",
      language: "en-US",
      title: "Viewed",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

    public static let mockDomain = Self(
      data: .init(viewed: true),
      image: .mockImage(width: 600, height: 400, backgroundColor: backgroundColor),
      imageAltText: "Domain captioned image card",
      language: "en-US",
      title: "Domain",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake.",
      domain: "domain.com"
    )

    public static let mockShort = Self(
      data: .init(viewed: true),
      image: .mockImage(width: 600, height: 400, backgroundColor: backgroundColor),
      imageAltText: "Short captioned image card",
      language: "en-US",
      title: "Short Text",
      description: "abc"
    )

    public static let mockLong = Self(
      data: .init(viewed: true),
      image: .mockImage(width: 600, height: 400, backgroundColor: backgroundColor),
      imageAltText: "Long captioned image card",
      language: "en-US",
      title:
        "Long Text | Cupcake ipsum dolor sit amet cake brownie powder. Pudding chupa chups toffee liquorice biscuit pastry dragée marshmallow bonbon. Gummi bears liquorice gingerbread donut pudding liquorice.",
      description:
        """
        Cupcake ipsum dolor sit amet cake brownie powder. Pudding chupa chups toffee liquorice biscuit pastry dragée marshmallow bonbon. Gummi bears liquorice gingerbread donut pudding liquorice.

        Tiramisu bear claw icing chocolate cake brownie halvah caramels. Pastry tiramisu toffee cookie gummies carrot cake candy canes fruitcake. Pastry marshmallow cake sweet roll cake muffin.

        Tootsie roll pudding danish brownie topping bonbon tart. Dragée gingerbread lollipop toffee candy jujubes. Wafer gummi bears jelly-o soufflé cake cheesecake apple pie caramels chupa chups. Wafer jelly beans jelly-o caramels chocolate cake chocolate cake cake candy.
        """
    )

    public static let mockExtraLong = Self(
      data: .init(viewed: true),
      image: .mockImage(width: 600, height: 400, backgroundColor: backgroundColor),
      imageAltText: "Extra long captioned image card",
      language: "en-US",
      title:
        "Extra Long Text | Cupcake ipsum dolor sit amet carrot cake tootsie roll jujubes. Powder tiramisu jelly beans cake bear claw chocolate oat cake cotton candy tart. Jelly lemon drops brownie chocolate bar brownie cotton candy. Brownie chupa chups jelly halvah jelly beans shortbread soufflé. Cheesecake oat cake oat cake apple pie cheesecake candy canes jelly-o. Candy canes cupcake muffin cotton candy lollipop pudding. Icing jelly-o shortbread icing icing. Jelly-o lollipop lemon drops cake tiramisu cheesecake. Croissant gummi bears powder gingerbread cotton candy.",
      description:
        """
        Cupcake ipsum dolor sit amet carrot cake tootsie roll jujubes. Powder tiramisu jelly beans cake bear claw chocolate oat cake cotton candy tart. Jelly lemon drops brownie chocolate bar brownie cotton candy. Brownie chupa chups jelly halvah jelly beans shortbread soufflé. Cheesecake oat cake oat cake apple pie cheesecake candy canes jelly-o. Candy canes cupcake muffin cotton candy lollipop pudding. Icing jelly-o shortbread icing icing. Jelly-o lollipop lemon drops cake tiramisu cheesecake. Croissant gummi bears powder gingerbread cotton candy.

        Halvah halvah lollipop cookie ice cream brownie macaroon shortbread. Pie sesame snaps chocolate chocolate cake cupcake danish. Jelly beans lemon drops icing tootsie roll marzipan croissant soufflé soufflé. Chupa chups marzipan apple pie pastry gingerbread. Jelly beans oat cake cotton candy chupa chups topping chocolate bar liquorice. Topping tiramisu lollipop gingerbread cake icing lemon drops candy canes sweet. Danish marzipan marshmallow cake pudding chocolate cake lollipop cake marshmallow. Chocolate fruitcake halvah oat cake tart powder cupcake marshmallow marshmallow.

        Brownie tootsie roll candy canes sweet bonbon. Gingerbread sugar plum sweet tart jelly-o. Sesame snaps tootsie roll soufflé lollipop jelly sugar plum halvah pastry wafer. Pie halvah tiramisu lemon drops jelly apple pie. Pastry shortbread carrot cake oat cake shortbread lollipop. Pudding sweet roll fruitcake marzipan halvah.

        Chocolate bar marshmallow bonbon cake cheesecake chocolate bar dessert muffin. Sugar plum dragée sesame snaps bear claw jelly fruitcake. Powder lollipop cupcake wafer marzipan donut pudding jujubes fruitcake. Gingerbread dragée dessert chupa chups cheesecake tart. Chocolate bar pudding cake cookie gummi bears icing. Wafer apple pie icing sesame snaps candy. Marzipan muffin icing marzipan cupcake bear claw cake. Caramels oat cake tiramisu cake candy jelly. Apple pie ice cream caramels candy canes carrot cake candy bear claw. Brownie sweet roll oat cake icing bear claw wafer.

        Sweet roll cookie jelly-o soufflé sugar plum bear claw dragée candy canes gummies. Cake carrot cake brownie donut chocolate gummies brownie cotton candy. Lollipop biscuit candy halvah chocolate cake biscuit sweet. Chocolate bar danish gummies pastry icing. Carrot cake pudding jujubes dragée toffee fruitcake toffee. Gingerbread caramels chupa chups jelly-o jujubes cookie sesame snaps.
        """
    )

    public static let mockEmptyAltText = Self(
      data: .init(viewed: true),
      image: .mockImage(width: 600, height: 400, backgroundColor: backgroundColor),
      imageAltText: "",
      language: "en-US",
      title: "Empty Alt Text",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
    )

  }

#endif
