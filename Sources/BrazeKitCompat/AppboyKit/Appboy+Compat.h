#import "Appboy.h"

@class Braze;

@interface Appboy ()

@property(strong, nonatomic) Braze *braze;

- (instancetype)initWithBraze:(Braze *)braze;

@end
