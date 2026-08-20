#import "ABKBaseContentCardCell.h"

#if __has_include(<BrazeKitCompat/BrazePreprocessor.h>)
  #import <BrazeKitCompat/BrazePreprocessor.h>
#else
  #import "BrazePreprocessor.h"
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@class ABKBannerContentCard;

BRZ_DEPRECATED("renamed to 'BrazeContentCardUI.ImageOnlyCell'")
@interface ABKBannerContentCardCell : ABKBaseContentCardCell

@property (strong, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageRatioConstraint;

- (void)applyCard:(ABKBannerContentCard *)bannerCard;

@end

#pragma clang diagnostic pop
