@import Foundation;

@class ReadmeViewController;

/// An action row within a ReadmeActionSection.
@interface ReadmeActionItem : NSObject

@property(copy, nonatomic) NSString *title;
@property(copy, nonatomic) NSString *subtitle;
@property(copy, nonatomic) void (^action)(ReadmeViewController *viewController);

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                       action:(void (^)(ReadmeViewController *viewController))action;

@end

/// An additional titled section of action rows, appended after the main "Actions" section.
@interface ReadmeActionSection : NSObject

@property(copy, nonatomic) NSString *title;
@property(copy, nonatomic) NSArray<ReadmeActionItem *> *items;

- (instancetype)initWithTitle:(NSString *)title items:(NSArray<ReadmeActionItem *> *)items;

@end

/// Extra action sections displayed after the main "Actions" section. Populate before the window
/// is created (e.g. in `application:didFinishLaunchingWithOptions:`).
NSMutableArray<ReadmeActionSection *> *readmeActionSections(void);
