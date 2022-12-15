#import "ABKLocationManager.h"

@class Braze;

@interface ABKLocationManager ()

@property(strong, nonatomic) Braze *braze;

- (instancetype)initWithBraze:(Braze *)braze;

@end
