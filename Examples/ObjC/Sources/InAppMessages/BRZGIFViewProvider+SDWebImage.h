@import Foundation;
@import BrazeUI;

@interface BRZGIFViewProvider (SDWebImage)

/// A GIF view provider using
/// [SDWebImage](https://github.com/SDWebImage/SDWebImage) as a rendering
/// library.
+ (BRZGIFViewProvider *)sdWebImage;

@end
