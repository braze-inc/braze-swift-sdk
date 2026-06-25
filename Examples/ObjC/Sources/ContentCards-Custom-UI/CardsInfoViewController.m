#import "CardsInfoViewController.h"

@import UIKit;
@import BrazeKit;

#pragma mark - Field / Section

@interface Field : NSObject

@property(copy, nonatomic) NSString *name;
@property(strong, nonatomic) id value;
@property(assign, nonatomic) NSInteger indentation;

+ (instancetype)fieldWithName:(NSString *)name value:(id)value;
+ (instancetype)fieldWithName:(NSString *)name
                        value:(id)value
                  indentation:(NSInteger)indentation;

@end

@interface Section : NSObject

@property(copy, nonatomic) NSString *name;
@property(strong, nonatomic) NSArray<Field *> *fields;

@end

#pragma mark - CardsInfoViewController

@interface CardsInfoViewController ()

@property(strong, nonatomic) Braze *braze;
@property(strong, nonatomic) NSArray<BRZContentCardRaw *> *cards;
@property(strong, nonatomic) NSArray<Section *> *sections;
// Must be retained to keep subscription active; cancelling re-applies local analytics.
@property(strong, nonatomic) BRZCancellable *subscription;
// Tracks cards already impressed in this presentation to avoid duplicate impression events.
@property(strong, nonatomic) NSMutableSet<NSString *> *impressedCardIDs;

+ (Section *)cardSectionFromCard:(BRZContentCardRaw *)card
                         atIndex:(NSInteger)index;

@end

@implementation CardsInfoViewController

- (instancetype)initWithBraze:(Braze *)braze {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.braze = braze;
    self.cards = @[];
    self.sections = @[];
    self.impressedCardIDs = [NSMutableSet set];

    self.title = @"Content Cards Info";

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                             target:self
                             action:@selector(dismissModal)];
    [self.navigationItem setRightBarButtonItem:doneButton];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Subscribe to content cards updates. Delivers an initial snapshot of cached cards
  // immediately, then subsequent updates as cards change. Cancelling re-applies local
  // analytics (viewed/clicked/removed) and notifies any remaining subscribers.
  // Note: impressions, clicks, and dismissals do not trigger the subscription callback
  __weak typeof(self) weakSelf = self;
  self.subscription = [self.braze.contentCards
      subscribeToUpdates:^(NSArray<BRZContentCardRaw *> *cards) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) return;
        strongSelf.cards = cards;
        NSMutableArray *sections = [NSMutableArray array];
        for (NSInteger i = 0; i < cards.count; ++i) {
          [sections addObject:[CardsInfoViewController cardSectionFromCard:cards[i]
                                                                   atIndex:i]];
        }
        strongSelf.sections = [sections copy];
        [strongSelf.tableView reloadData];
      }];
}

- (void)dismissModal {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return self.sections[section].fields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                  reuseIdentifier:@"cellIdentifier"];
  }

  Field *field = self.sections[indexPath.section].fields[indexPath.row];
  cell.textLabel.text = field.name;
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", field.value];
  cell.indentationLevel = field.indentation;

  cell.textLabel.numberOfLines = 0;
  if (@available(iOS 13.0, tvOS 13.0, *)) {
    cell.textLabel.font =
        [UIFont monospacedSystemFontOfSize:13 weight:UIFontWeightRegular];
    cell.detailTextLabel.font =
        [UIFont monospacedSystemFontOfSize:13 weight:UIFontWeightRegular];
  }

  return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  return self.sections[section].name;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForFooterInSection:(NSInteger)section {
  UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [dismissButton setTitle:@"Log Dismissal" forState:UIControlStateNormal];
  dismissButton.tag = section;
  [dismissButton addTarget:self
                    action:@selector(logDismissal:)
          forControlEvents:UIControlEventTouchUpInside];

  UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [clickButton setTitle:@"Log Click" forState:UIControlStateNormal];
  clickButton.tag = section;
  [clickButton addTarget:self
                  action:@selector(logClick:)
        forControlEvents:UIControlEventTouchUpInside];

  UIStackView *stack = [[UIStackView alloc]
      initWithArrangedSubviews:@[ clickButton, dismissButton ]];
  stack.axis = UILayoutConstraintAxisVertical;
  stack.spacing = 8;

  UIView *container = [[UIView alloc] init];
  [container addSubview:stack];
  stack.translatesAutoresizingMaskIntoConstraints = NO;
  [NSLayoutConstraint activateConstraints:@[
    [stack.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
    [stack.topAnchor constraintEqualToAnchor:container.topAnchor constant:8],
    [stack.bottomAnchor constraintEqualToAnchor:container.bottomAnchor
                                        constant:-8],
  ]];
  return container;
}

// Log an impression when the first row of each card section becomes visible.
// Deduplication prevents a second impression if the card scrolls off-screen and back.
- (void)tableView:(UITableView *)tableView
    willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row != 0) return;
  BRZContentCardRaw *card = self.cards[indexPath.section];
  if ([self.impressedCardIDs containsObject:card.identifier]) return;
  [self.impressedCardIDs addObject:card.identifier];
  [card.context logImpression];
}

- (void)logClick:(UIButton *)sender {
  BRZContentCardRaw *card = self.cards[sender.tag];
  [card.context logClick];
  if (card.url != nil) {
    [card.context processClickActionWithURL:card.url useWebView:card.useWebView];
  }
  [sender setTitle:@"Log Click ✅" forState:UIControlStateNormal];
}

- (void)logDismissal:(UIButton *)sender {
  [self.cards[sender.tag].context logDismissed];
  [sender setTitle:@"Log Dismissal ✅" forState:UIControlStateNormal];
  // logDismissed marks the card locally but does not immediately trigger the subscription
  // callback. In a production UI, you would also remove the card from your view here
  // rather than waiting for the next update.
}

+ (Section *)cardSectionFromCard:(BRZContentCardRaw *)card
                         atIndex:(NSInteger)index {
  NSMutableArray *fields = [NSMutableArray array];

  switch (card.type) {
  case BRZContentCardRawTypeClassic:
    [fields addObject:[Field fieldWithName:@"type" value:@"classic"]];
    break;
  case BRZContentCardRawTypeImageOnly:
    [fields addObject:[Field fieldWithName:@"type" value:@"banner"]];
    break;
  case BRZContentCardRawTypeCaptionedImage:
    [fields addObject:[Field fieldWithName:@"type" value:@"captionedImage"]];
    break;
  case BRZContentCardRawTypeControl:
    [fields addObject:[Field fieldWithName:@"type" value:@"control"]];
    break;
  default:
    break;
  }

  [fields addObject:[Field fieldWithName:@"id" value:card.identifier]];
  [fields addObject:[Field fieldWithName:@"image" value:card.image]];
  [fields addObject:[Field fieldWithName:@"imageAspectRation"
                                   value:@(card.imageAspectRatio)]];
  [fields addObject:[Field fieldWithName:@"title" value:card.title]];
  [fields addObject:[Field fieldWithName:@"description"
                                   value:card.cardDescription]];
  [fields addObject:[Field fieldWithName:@"domain" value:card.domain]];
  [fields addObject:[Field fieldWithName:@"url" value:card.url]];
  [fields addObject:[Field fieldWithName:@"useWebView"
                                   value:card.useWebView ? @"true" : @"false"]];
  [fields addObject:[Field fieldWithName:@"viewed"
                                   value:card.viewed ? @"true" : @"false"]];
  [fields addObject:[Field fieldWithName:@"dismissible"
                                   value:card.dismissible ? @"true" : @"false"]];
  [fields addObject:[Field fieldWithName:@"removed"
                                   value:card.removed ? @"true" : @"false"]];
  [fields addObject:[Field fieldWithName:@"pinned"
                                   value:card.pinned ? @"true" : @"false"]];
  [fields addObject:[Field fieldWithName:@"clicked"
                                   value:card.clicked ? @"true" : @"false"]];
  [fields addObject:[Field fieldWithName:@"test"
                                   value:card.test ? @"true" : @"false"]];
  [fields addObject:[Field fieldWithName:@"createdAt" value:@(card.createdAt)]];
  [fields addObject:[Field fieldWithName:@"expiresAt" value:@(card.expiresAt)]];

  NSData *extrasData = [NSJSONSerialization dataWithJSONObject:card.extras
                                                       options:0
                                                         error:nil];
  NSString *extrasString = [[NSString alloc] initWithData:extrasData
                                                 encoding:NSUTF8StringEncoding];
  [fields addObject:[Field fieldWithName:@"extras" value:@""]];
  [fields addObject:[Field fieldWithName:extrasString value:@"" indentation:1]];

  Section *section = [[Section alloc] init];
  section.name = [NSString stringWithFormat:@"Card %ld", index];
  section.fields = [fields copy];

  return section;
}

@end

#pragma mark - Field / Section Implementation

@implementation Field

- (instancetype)initWithName:(NSString *)name value:(id)value {
  self = [super init];
  if (self) {
    self.name = name;
    self.value = value;
  }
  return self;
}

+ (instancetype)fieldWithName:(NSString *)name value:(id)value {
  return [[Field alloc] initWithName:name value:value];
}

+ (instancetype)fieldWithName:(NSString *)name
                        value:(id)value
                  indentation:(NSInteger)indentation {
  Field *field = [Field fieldWithName:name value:value];
  field.indentation = indentation;
  return field;
}

@end

@implementation Section
@end
