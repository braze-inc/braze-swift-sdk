#import "ReadmeViewController.h"
#import "AppDelegate.h"
#import "ReadmeAction.h"

extern NSString *const readme;
extern ReadmeAction const actions[];
extern NSInteger const actionsCount;

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

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return actionsCount;
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  return @"Actions";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *const identifier = @"cellIdentifier";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:identifier];
  }
  cell.textLabel.text = actions[indexPath.row].title;
  cell.detailTextLabel.text = actions[indexPath.row].subtitle;
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  void (^action)(ReadmeViewController *) = actions[indexPath.row].action;
  action(self);
  [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - Lazy Properties Instanciation

- (UITextView *)readmeTextView {
  if (!_readmeTextView) {
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor = UIColor.clearColor;
    [textView setScrollEnabled:NO];

#if TARGET_OS_IOS
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
