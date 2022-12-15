#import "ABKBaseContentCardCell.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@class ABKBannerContentCard;

@interface ABKBannerContentCardCell : ABKBaseContentCardCell

@property (strong, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageRatioConstraint;

- (void)applyCard:(ABKBannerContentCard *)bannerCard;

@end

#pragma clang diagnostic pop
