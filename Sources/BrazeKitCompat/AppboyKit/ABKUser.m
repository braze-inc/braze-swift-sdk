#import "ABKUser.h"
#import "ABKAttributionData+Compat.h"
#import "ABKUser+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation ABKUser

- (NSString *)firstName {
  return self.user.firstName;
}

- (void)setFirstName:(NSString *)firstName {
  [self.user setFirstName:firstName];
}

- (NSString *)lastName {
  return self.user.lastName;
}

- (void)setLastName:(NSString *)lastName {
  [self.user setLastName:lastName];
}

- (NSString *)email {
  return self.user.email;
}

- (void)setEmail:(NSString *)email {
  [self.user setEmail:email];
}

- (NSDate *)dateOfBirth {
  return self.user.dateOfBirth;
}

- (void)setDateOfBirth:(NSDate *)dateOfBirth {
  [self.user setDateOfBirth:dateOfBirth];
}

- (NSString *)country {
  return self.user.country;
}

- (void)setCountry:(NSString *)country {
  [self.user setCountry:country];
}

- (NSString *)homeCity {
  return self.user.homeCity;
}

- (void)setHomeCity:(NSString *)homeCity {
  [self.user setHomeCity:homeCity];
}

- (NSString *)language {
  return self.user.language;
}

- (void)setLanguage:(NSString *)language {
  [self.user setLanguage:language];
}

- (NSString *)userID {
  return self.user.userID;
}

- (NSString *)avatarImageURL {
  return self.user.avatarImageURL;
}

- (void)setAvatarImageURL:(NSString *)avatarImageURL {
  [self.user setAvatarImageURL:avatarImageURL];
}

- (ABKFacebookUser *)facebookUser {
  return self.user.facebookUser;
}

- (void)setFacebookUser:(ABKFacebookUser *)facebookUser {
  [self.user setFacebookUser:facebookUser];
}

- (ABKTwitterUser *)twitterUser {
  return self.user.twitterUser;
}

- (void)setTwitterUser:(ABKTwitterUser *)twitterUser {
  [self.user setTwitterUser:twitterUser];
}

- (ABKAttributionData *)attributionData {
  // Cannot really be made available on BRZUser
  return nil;
}

- (void)setAttributionData:(ABKAttributionData *)attributionData {
  [self.user setAttributionData:attributionData.data];
}

- (BOOL)addAlias:(NSString *)alias withLabel:(NSString *)label {
  [self.user addAlias:alias label:label];
  return YES;
}

- (BOOL)setGender:(ABKUserGenderType)gender {
  BRZUserGender *brzGender;
  switch (gender) {
  case ABKUserGenderMale:
    brzGender = BRZUserGender.male;
    break;
  case ABKUserGenderFemale:
    brzGender = BRZUserGender.female;
    break;
  case ABKUserGenderOther:
    brzGender = BRZUserGender.other;
    break;
  case ABKUserGenderUnknown:
    brzGender = BRZUserGender.unknown;
    break;
  case ABKUserGenderNotApplicable:
    brzGender = BRZUserGender.notApplicable;
    break;
  default:
    brzGender = BRZUserGender.unknown;
    break;
  }
  [self.user setGender:brzGender];
  return YES;
}

- (BOOL)setEmailNotificationSubscriptionType:
    (ABKNotificationSubscriptionType)emailNotificationSubscriptionType {
  [self.user setEmailSubscriptionState:(BRZUserSubscriptionState)
                                           emailNotificationSubscriptionType];
  return YES;
}

- (BOOL)setPushNotificationSubscriptionType:
    (ABKNotificationSubscriptionType)pushNotificationSubscriptionType {
  [self.user setPushNotificationSubscriptionState:
                 (BRZUserSubscriptionState)pushNotificationSubscriptionType];
  return YES;
}

- (BOOL)addToSubscriptionGroupWithGroupId:(NSString *)groupId {
  [self.user addToSubscriptionGroupWithGroupId:groupId];
  return YES;
}

- (BOOL)removeFromSubscriptionGroupWithGroupId:(NSString *)groupId {
  [self.user removeFromSubscriptionGroupWithGroupId:groupId];
  return YES;
}

- (BOOL)setCustomAttributeWithKey:(NSString *)key andBOOLValue:(BOOL)value {
  [self.user setCustomAttributeWithKey:key boolValue:value];
  return YES;
}

- (BOOL)setCustomAttributeWithKey:(NSString *)key
                  andIntegerValue:(NSInteger)value {
  [self.user setCustomAttributeWithKey:key intValue:value];
  return YES;
}

- (BOOL)setCustomAttributeWithKey:(NSString *)key andDoubleValue:(double)value {
  [self.user setCustomAttributeWithKey:key doubleValue:value];
  return YES;
}

- (BOOL)setCustomAttributeWithKey:(NSString *)key
                   andStringValue:(NSString *)value {
  [self.user setCustomAttributeWithKey:key stringValue:value];
  return YES;
}

- (BOOL)setCustomAttributeWithKey:(NSString *)key andDateValue:(NSDate *)value {
  [self.user setCustomAttributeWithKey:key dateValue:value];
  return YES;
}

- (BOOL)unsetCustomAttributeWithKey:(NSString *)key {
  [self.user unsetCustomAttributeWithKey:key];
  return YES;
}

- (BOOL)incrementCustomUserAttribute:(NSString *)key {
  [self.user incrementCustomUserAttribute:key];
  return YES;
}

- (BOOL)incrementCustomUserAttribute:(NSString *)key
                                  by:(NSInteger)incrementValue {
  [self.user incrementCustomUserAttribute:key by:incrementValue];
  return YES;
}

- (BOOL)addToCustomAttributeArrayWithKey:(NSString *)key
                                   value:(NSString *)value {
  [self.user addToCustomAttributeArrayWithKey:key value:value];
  return YES;
}

- (BOOL)removeFromCustomAttributeArrayWithKey:(NSString *)key
                                        value:(NSString *)value {
  [self.user removeFromCustomAttributeArrayWithKey:key value:value];
  return YES;
}

- (BOOL)setCustomAttributeArrayWithKey:(NSString *)key
                                 array:(NSArray *)valueArray {
  [self.user setCustomAttributeArrayWithKey:key array:valueArray];
  return YES;
}

- (BOOL)setLastKnownLocationWithLatitude:(double)latitude
                               longitude:(double)longitude
                      horizontalAccuracy:(double)horizontalAccuracy {
  [self.user setLastKnownLocationWithLatitude:latitude
                                    longitude:longitude
                           horizontalAccuracy:horizontalAccuracy];
  return YES;
}

- (BOOL)setLastKnownLocationWithLatitude:(double)latitude
                               longitude:(double)longitude
                      horizontalAccuracy:(double)horizontalAccuracy
                                altitude:(double)altitude
                        verticalAccuracy:(double)verticalAccuracy {
  [self.user setLastKnownLocationWithLatitude:latitude
                                    longitude:longitude
                                     altitude:altitude
                           horizontalAccuracy:horizontalAccuracy
                             verticalAccuracy:verticalAccuracy];
  return YES;
}

- (BOOL)addLocationCustomAttributeWithKey:(NSString *)key
                                 latitude:(double)latitude
                                longitude:(double)longitude {
  [self.user setLocationCustomAttributeWithKey:key
                                      latitude:latitude
                                     longitude:longitude];
  return YES;
}

- (BOOL)removeLocationCustomAttributeWithKey:(NSString *)key {
  [self.user unsetLocationCustomAttributeWithKey:key];
  return YES;
}

- (instancetype)initWithUser:(BRZUser *)user {
  self = [super init];
  if (self) {
    _user = user;
  }
  return self;
}

@end

#pragma clang diagnostic pop
