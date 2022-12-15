#import "ABKAttributionData.h"
#import "ABKAttributionData+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation ABKAttributionData

- (NSString *)network {
  return self.data.network;
}

- (NSString *)campaign {
  return self.data.campaign;
}

- (NSString *)adGroup {
  return self.data.adGroup;
}

- (NSString *)creative {
  return self.data.creative;
}

- (instancetype)init {
  return [self initWithNetwork:nil campaign:nil adGroup:nil creative:nil];
}

- (instancetype)initWithNetwork:(NSString *)network
                       campaign:(NSString *)campaign
                        adGroup:(NSString *)adGroup
                       creative:(NSString *)creative {
  BRZUserAttributionData *data =
      [[BRZUserAttributionData alloc] initWithNetwork:network
                                             campaign:campaign
                                              adGroup:adGroup
                                             creative:creative];
  self = [self initWithUserAttributionData:data];
  return self;
}

- (instancetype)initWithUserAttributionData:(BRZUserAttributionData *)data {
  self = [super init];
  if (self) {
    _data = data;
  }
  return self;
}

@end

#pragma clang diagnostic pop
