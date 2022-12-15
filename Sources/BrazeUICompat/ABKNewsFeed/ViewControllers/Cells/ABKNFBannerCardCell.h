#import "ABKNFBaseCardCell.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@class ABKCard;

@interface ABKNFBannerCardCell : ABKNFBaseCardCell

@property (nonatomic) IBOutlet UIImageView *bannerImageView;
@property (nonatomic) IBOutlet NSLayoutConstraint *imageRatioConstraint;

/*!
 * @discussion Programmatic initialization and layout of the banner imageView, exposed for customization.
 */
- (void)setUpBannerImageView;

- (void)applyCard:(ABKCard *)bannerCard;

@end

#pragma clang diagnostic pop
