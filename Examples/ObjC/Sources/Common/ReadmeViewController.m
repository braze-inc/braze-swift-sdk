#import "ReadmeViewController.h"
#import "AppDelegate.h"
#import "ReadmeAction.h"
#import "ReadmeActionSection.h"
#import "ReadmeTextField.h"

extern NSString *const readme;
extern ReadmeAction const actions[];
extern NSInteger const actionsCount;

#pragma mark - ReadmeTextFieldCell

@interface ReadmeTextFieldCell : UITableViewCell

@property(strong, nonatomic) UITextField *textField;
@property(strong, nonatomic) UIButton *button;
@property(copy, nonatomic) void (^onSubmit)(NSString *text);

@end

@implementation ReadmeTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _textField = [[UITextField alloc] init];
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:_textField];

    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    [_button addTarget:self
                  action:@selector(submit)
        forControlEvents:UIControlEventTouchUpInside];
    [_button setContentHuggingPriority:UILayoutPriorityRequired
                               forAxis:UILayoutConstraintAxisHorizontal];
    [_button setContentCompressionResistancePriority:UILayoutPriorityRequired
                                             forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:_button];

    UILayoutGuide *margins = self.contentView.layoutMarginsGuide;
    [NSLayoutConstraint activateConstraints:@[
      [_textField.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor],
      [_textField.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
      [_textField.trailingAnchor constraintEqualToAnchor:_button.leadingAnchor constant:-8],
      [_button.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor],
      [_button.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
      [self.contentView.heightAnchor constraintGreaterThanOrEqualToConstant:44],
    ]];
  }
  return self;
}

- (void)submit {
  if (self.onSubmit) {
    self.onSubmit(self.textField.text ?: @"");
  }
  [self.textField resignFirstResponder];
}

@end

@interface ReadmeViewController ()

@property(strong, nonatomic) UITextView *readmeTextView;

@end

@implementation ReadmeViewController

- (instancetype)init {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {

    // Set title
    self.title = [NSBundle.mainBundle
        objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];

    // Set readme text
    self.readmeTextView.text =
        [NSString stringWithFormat:@"# Readme\n\n%@", readme];
    self.tableView.tableHeaderView = self.readmeTextView;
  }
  return self;
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  CGSize size = [self.readmeTextView
      systemLayoutSizeFittingSize:(CGSize){self.tableView.bounds.size.width,
                                           1000}];
  if (self.readmeTextView.frame.size.height != size.height) {
    CGRect frame = self.readmeTextView.frame;
    frame.size.height = size.height;
    self.readmeTextView.frame = frame;
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)textFieldSectionCount {
  return readmeTextFields().count > 0 ? 1 : 0;
}

- (BOOL)isTextFieldSection:(NSInteger)section {
  return [self textFieldSectionCount] > 0 && section == 0;
}

- (BOOL)isMainActionsSection:(NSInteger)section {
  return section == [self textFieldSectionCount];
}

- (ReadmeActionSection *)extraSectionForSection:(NSInteger)section {
  NSInteger index = section - [self textFieldSectionCount] - 1;
  if (index < 0 || index >= (NSInteger)readmeActionSections().count) {
    return nil;
  }
  return readmeActionSections()[index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self textFieldSectionCount] + 1 + readmeActionSections().count;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  if ([self isTextFieldSection:section]) {
    return readmeTextFields().count;
  }
  if ([self isMainActionsSection:section]) {
    return actionsCount;
  }
  return [self extraSectionForSection:section].items.count;
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  if ([self isTextFieldSection:section]) {
    return @"User";
  }
  if ([self isMainActionsSection:section]) {
    return @"Actions";
  }
  return [self extraSectionForSection:section].title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self isTextFieldSection:indexPath.section]) {
    NSString *const identifier = @"textFieldCellIdentifier";
    ReadmeTextFieldCell *cell =
        (ReadmeTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
      cell = [[ReadmeTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:identifier];
    }
    ReadmeTextField *row = readmeTextFields()[indexPath.row];
    cell.textField.placeholder = row.placeholder;
    [cell.button setTitle:row.buttonTitle forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    cell.onSubmit = ^(NSString *text) {
      row.action(text, weakSelf);
    };
    return cell;
  }

  NSString *const identifier = @"cellIdentifier";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:identifier];
  }
  if ([self isMainActionsSection:indexPath.section]) {
    cell.textLabel.text = actions[indexPath.row].title;
    cell.detailTextLabel.text = actions[indexPath.row].subtitle;
  } else {
    ReadmeActionItem *item =
        [self extraSectionForSection:indexPath.section].items[indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subtitle;
  }
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self isTextFieldSection:indexPath.section]) {
    return;
  }
  if ([self isMainActionsSection:indexPath.section]) {
    actions[indexPath.row].action(self);
  } else {
    [self extraSectionForSection:indexPath.section].items[indexPath.row].action(self);
  }
  [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - Text fields

- (void)clearTextFields {
  for (UITableViewCell *cell in self.tableView.visibleCells) {
    if ([cell isKindOfClass:[ReadmeTextFieldCell class]]) {
      ((ReadmeTextFieldCell *)cell).textField.text = nil;
    }
  }
}

#pragma mark - Lazy Properties Instanciation

- (UITextView *)readmeTextView {
  if (!_readmeTextView) {
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor = UIColor.clearColor;
    [textView setScrollEnabled:NO];

#if TARGET_OS_IOS || TARGET_OS_VISION
    [textView setEditable:NO];
    textView.textContainerInset = UIEdgeInsetsMake(16, 16, 0, 16);
    if (@available(iOS 13.0, *)) {
      textView.font = [UIFont monospacedSystemFontOfSize:12
                                                  weight:UIFontWeightRegular];
    }
#elif TARGET_OS_TV
    textView.textContainerInset = UIEdgeInsetsMake(0, 16 * 6, 16 * 4, 16 * 6);
    if (@available(tvOS 13.0, *)) {
      textView.font = [UIFont monospacedSystemFontOfSize:30
                                                  weight:UIFontWeightRegular];
    }
#endif

    _readmeTextView = textView;
  }
  return _readmeTextView;
}

@end

#pragma mark - AutoReadme

static NSString *const _window;

@implementation AppDelegate (AutoWindow)

+ (UIWindow *)_auto_window {
  static dispatch_once_t once;
  static UIWindow *window;
  dispatch_once(&once, ^{
    ReadmeViewController *readmeViewController =
        [[ReadmeViewController alloc] init];
    UINavigationController *navigationController =
        [[UINavigationController alloc]
            initWithRootViewController:readmeViewController];
    window = [[UIWindow alloc] init];
    window.rootViewController = navigationController;
  });
  return window;
}

- (UIWindow *)window {
  return [AppDelegate _auto_window];
}

- (void)setWindow:(UIWindow *)window {
  // noop
}

@end
