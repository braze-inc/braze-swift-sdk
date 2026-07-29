@import Foundation;

@class ReadmeViewController;

/// A row rendered as an editable text field with a trailing button, used by ReadmeViewController.
@interface ReadmeTextField : NSObject

@property(copy, nonatomic) NSString *placeholder;
@property(copy, nonatomic) NSString *buttonTitle;
@property(copy, nonatomic) void (^action)(NSString *text, ReadmeViewController *viewController);

- (instancetype)initWithPlaceholder:(NSString *)placeholder
                        buttonTitle:(NSString *)buttonTitle
                             action:(void (^)(NSString *text,
                                              ReadmeViewController *viewController))action;

@end

/// Text field rows displayed above the action rows. Populate before the window is created
/// (e.g. in `application:didFinishLaunchingWithOptions:`).
NSMutableArray<ReadmeTextField *> *readmeTextFields(void);
