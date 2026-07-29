#import "ReadmeTextField.h"

@implementation ReadmeTextField

- (instancetype)initWithPlaceholder:(NSString *)placeholder
                        buttonTitle:(NSString *)buttonTitle
                             action:(void (^)(NSString *,
                                              ReadmeViewController *))action {
  self = [super init];
  if (self) {
    _placeholder = [placeholder copy];
    _buttonTitle = [buttonTitle copy];
    _action = [action copy];
  }
  return self;
}

@end

NSMutableArray<ReadmeTextField *> *readmeTextFields(void) {
  static NSMutableArray *rows;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    rows = [NSMutableArray array];
  });
  return rows;
}
