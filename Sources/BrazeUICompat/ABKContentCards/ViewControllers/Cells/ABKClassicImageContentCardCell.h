#import "ABKClassicContentCardCell.h"

#if __has_include(<BrazeKitCompat/BrazePreprocessor.h>)
  #import <BrazeKitCompat/BrazePreprocessor.h>
#else
  #import "BrazePreprocessor.h"
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@class ABKClassicContentCard;

/*!
 * The ABKClassicContentCard has an optional image property.
 * Use this view controller for a classic card with an image and ABKClassicContentCardCell for a
 * classic card without an image.
 */
BRZ_DEPRECATED("renamed to 'BrazeContentCardUI.ClassicImageCell'")
@interface ABKClassicImageContentCardCell : ABKClassicContentCardCell

@property (strong, nonatomic) IBOutlet UIImageView *classicImageView;

- (void)applyCard:(ABKClassicContentCard *)classicCard;

@end

#pragma clang diagnostic pop
