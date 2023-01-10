#import "ReadmeAction.h"

@import CoreLocation;

#pragma mark - Internal

static CLLocationManager *_locationManager;

CLLocationManager *locationManager(void) {
  if (!_locationManager) {
    _locationManager = [[CLLocationManager alloc] init];
  }
  return _locationManager;
}

#if TARGET_OS_IOS

void requestAlwaysAuthorization(ReadmeViewController *viewController) {
  [locationManager() requestAlwaysAuthorization];
}

#endif

void requestWhenInUseAuthorization(ReadmeViewController *viewController) {
  [locationManager() requestWhenInUseAuthorization];
}

#pragma mark - Readme

NSString *const readme =
    @"This sample presents a complete BrazeLocation integration.\n"
    @"\n"
    @"- AppDelegate.{h,m}:\n"
    @"  - Configure the braze instance with BrazeLocationProvider";

#if TARGET_OS_IOS

NSInteger const actionsCount = 2;

ReadmeAction const actions[] = {
    {@"Request \"always\" authorization", @"",
     ^(ReadmeViewController *_Nonnull viewController){
         requestAlwaysAuthorization(viewController);
}
}
, {@"Request \"when in use\" authorization", @"",
   ^(ReadmeViewController *_Nonnull viewController){
       requestWhenInUseAuthorization(viewController);
}
}
,
}
;

#elif TARGET_OS_TV

NSInteger const actionsCount = 1;

ReadmeAction const actions[] = {
    {@"Request \"when in use\" authorization", @"",
     ^(ReadmeViewController *_Nonnull viewController){
         requestWhenInUseAuthorization(viewController);
}
}
,
}
;

#endif
