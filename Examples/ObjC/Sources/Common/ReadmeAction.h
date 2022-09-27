@import Foundation;

@class ReadmeViewController;

typedef struct ReadmeAction {
  NSString *title;
  NSString *subtitle;
  void (^action)(ReadmeViewController *);
} ReadmeAction;
