#import "ABKBaseContentCardCell.h"

#if __has_include(<BrazeKitCompat/BrazePreprocessor.h>)
  #import <BrazeKitCompat/BrazePreprocessor.h>
#else
  #import "BrazePreprocessor.h"
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@class ABKClassicContentCard;

BRZ_DEPRECATED("renamed to 'BrazeContentCardUI.ClassicCell'")
@interface ABKClassicContentCardCell : ABKBaseContentCardCell

@property (class, nonatomic) UIColor *titleLabelColor;
@property (class, nonatomic) UIColor *descriptionLabelColor;
@property (class, nonatomic) UIColor *linkLabelColor;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *linkLabel;

@property (strong, nonatomic) NSArray *descriptionConstraints;
@property (strong, nonatomic) NSArray *linkConstraints;

@property (nonatomic, assign) CGFloat padding;

- (void)applyCard:(ABKClassicContentCard *)classicCard;

@end

#pragma clang diagnostic pop
