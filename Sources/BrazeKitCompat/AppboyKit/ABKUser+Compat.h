#import "ABKUser.h"

@class BRZUser;

@interface ABKUser ()

@property(strong, nonatomic) BRZUser *user;

- (instancetype)initWithUser:(BRZUser *)user;

@end
