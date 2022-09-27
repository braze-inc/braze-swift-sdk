@import Foundation;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - User

@interface User : NSObject

@property(copy, nonatomic) NSString *identifier;
@property(copy, nonatomic) NSString *email;
@property(strong, nonatomic) NSDate *birthday;

@end

#pragma mark - AuthenticationManager

@interface AuthenticationManager : NSObject

- (void)userDidLogin:(User *)user;

@end

NS_ASSUME_NONNULL_END
