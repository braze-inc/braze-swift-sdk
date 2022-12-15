#import "ABKFacebookUser.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

NSInteger const DefaultNumberOfFriends = -1;

@implementation ABKFacebookUser

- (instancetype)initWithFacebookUserDictionary:
                    (NSDictionary *)facebookUserDictionary
                               numberOfFriends:(NSInteger)numberOfFriends
                                         likes:(NSArray *)likes {
  self = [super init];
  if (self) {
    _facebookUserDictionary =
        [[NSDictionary alloc] initWithDictionary:facebookUserDictionary
                                       copyItems:YES];
    _numberOfFriends = numberOfFriends;
    _likes = [[NSArray alloc] initWithArray:likes copyItems:YES];
  }
  return self;
}

// Setting default value of _numberOfFriends to be -1
- (instancetype)init {
  if (self = [super init]) {
    _numberOfFriends = DefaultNumberOfFriends;
  }
  return self;
}

@end

#pragma clang diagnostic pop
