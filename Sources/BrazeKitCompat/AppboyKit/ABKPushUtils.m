#import "ABKPushUtils.h"
#import "../BRZLog.h"
#import "ABKPushUtils+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

#if !TARGET_OS_TV

@import BrazeKit;

static NSString *const ABKApsPushPayloadKey = @"aps";
static NSString *const ABKContentAvailablePushPayloadKey = @"content-available";
static NSString *const ABKAppboyPushPayloadKey = @"ab";
static NSString *const ABKSyncGeofencesPushPayloadKey = @"ab_sync_geos";
static NSString *const ABKFetchTestTriggerPushPayloadKey =
    @"ab_push_fetch_test_triggers_key";
static NSString *const ABKUninstallTrackingPushPayloadKey =
    @"appboy_uninstall_tracking";
static NSString *const ABKPushStoryPayloadKey = @"ab_carousel";
static NSString *const ABKContentCardPushPayloadKey = @"ab_cd";

@implementation ABKPushUtils

+ (BOOL)isAppboyUserNotification:(UNNotificationResponse *)response {
  return [self isAppboyRemoteNotification:response.notification.request.content
                                              .userInfo];
}

+ (BOOL)isAppboyRemoteNotification:(NSDictionary *)userInfo {
  NSDictionary *ab = userInfo[ABKAppboyPushPayloadKey];
  return [ab isKindOfClass:[NSDictionary class]] && ab.count > 0;
}

+ (BOOL)isAppboyInternalRemoteNotification:(NSDictionary *)userInfo {
  return [self isUninstallTrackingRemoteNotification:userInfo] ||
         [self isGeofencesSyncRemoteNotification:userInfo];
}

+ (BOOL)isUninstallTrackingUserNotification:(UNNotificationResponse *)response {
  return
      [self isUninstallTrackingRemoteNotification:response.notification.request
                                                      .content.userInfo];
}

+ (BOOL)isUninstallTrackingRemoteNotification:(NSDictionary *)userInfo {
  return [userInfo[ABKUninstallTrackingPushPayloadKey] boolValue];
}

+ (BOOL)isGeofencesSyncUserNotification:(UNNotificationResponse *)response {
  return [self isGeofencesSyncRemoteNotification:response.notification.request
                                                     .content.userInfo];
}

+ (BOOL)isGeofencesSyncRemoteNotification:(NSDictionary *)userInfo {
  NSDictionary *appboyDict = userInfo[ABKAppboyPushPayloadKey];
  return [appboyDict[ABKSyncGeofencesPushPayloadKey] boolValue];
}

+ (BOOL)isAppboySilentRemoteNotification:(NSDictionary *)userInfo {
  if (![self isAppboyRemoteNotification:userInfo]) {
    return NO;
  }

  NSDictionary *aps = userInfo[ABKApsPushPayloadKey];
  if (!([aps isKindOfClass:[NSDictionary class]] && aps.count > 0)) {
    return NO;
  }

  return [aps[ABKContentAvailablePushPayloadKey] intValue] == 1;
}

+ (BOOL)isPushStoryRemoteNotification:(NSDictionary *)userInfo {
  NSDictionary *appboyDict = userInfo[ABKAppboyPushPayloadKey];
  return [appboyDict[ABKPushStoryPayloadKey] boolValue];
}

+ (BOOL)notificationContainsContentCard:(NSDictionary *)userInfo {
  return userInfo[ABKAppboyPushPayloadKey][ABKContentCardPushPayloadKey] != nil;
}

+ (BOOL)shouldFetchTestTriggersFlagContainedInPayload:(NSDictionary *)userInfo {
  return [userInfo[ABKFetchTestTriggerPushPayloadKey] boolValue];
}

+ (NSSet<UNNotificationCategory *> *)getAppboyUNNotificationCategorySet {
  return BRZNotifications.categories;
}

+ (NSSet<UIUserNotificationCategory *> *)
    getAppboyUIUserNotificationCategorySet {
  LogUnimplemented();
  return [NSSet set];
}

@end
#endif

#pragma clang diagnostic pop
