#import "ABKBaseContentCardCell.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@class ABKCaptionedImageContentCard;

@interface ABKCaptionedImageContentCardCell : ABKBaseContentCardCell

@property (class, nonatomic) UIColor *titleLabelColor;
@property (class, nonatomic) UIColor *descriptionLabelColor;
@property (class, nonatomic) UIColor *linkLabelColor;

@property (strong, nonatomic) IBOutlet UIImageView *captionedImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageRatioConstraint;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *linkLabel;

@property (nonatomic, assign) CGFloat padding;

- (void)applyCard:(ABKCaptionedImageContentCard *)captionedImageCard;

@end

#pragma clang diagnostic pop
