#import "ABKLocationManager.h"
#import "../BRZLog.h"
#import "ABKLocationManager+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation ABKLocationManager

- (BOOL)enableLocationTracking {
  return self.braze.configuration.location.automaticLocationCollection;
}

- (BOOL)enableGeofences {
  return self.braze.configuration.location.geofencesEnabled;
}

- (BOOL)disableAutomaticGeofenceRequests {
  return !self.braze.configuration.location.automaticGeofenceRequests;
}

- (void)logSingleLocation {
  LogUnimplemented();
}

- (instancetype)initWithBraze:(Braze *)braze {
  self = [super init];
  if (self) {
    _braze = braze;
  }
  return self;
}

@end

#pragma clang diagnostic pop
