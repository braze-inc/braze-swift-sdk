#import "ABKAttributionData.h"

@class BRZUserAttributionData;

@interface ABKAttributionData ()

@property(strong, nonatomic) BRZUserAttributionData *data;

- (instancetype)initWithUserAttributionData:(BRZUserAttributionData *)data;

@end
