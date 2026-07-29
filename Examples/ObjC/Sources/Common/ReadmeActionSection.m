#import "ReadmeActionSection.h"

@implementation ReadmeActionItem

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                       action:(void (^)(ReadmeViewController *))action {
  self = [super init];
  if (self) {
    _title = [title copy];
    _subtitle = [subtitle copy];
    _action = [action copy];
  }
  return self;
}

@end

@implementation ReadmeActionSection

- (instancetype)initWithTitle:(NSString *)title items:(NSArray<ReadmeActionItem *> *)items {
  self = [super init];
  if (self) {
    _title = [title copy];
    _items = [items copy];
  }
  return self;
}

@end

NSMutableArray<ReadmeActionSection *> *readmeActionSections(void) {
  static NSMutableArray *sections;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    sections = [NSMutableArray array];
  });
  return sections;
}
