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

@property(strong, nonatomic) NSArray<Section *> *sections;

+ (Section *)cardSectionFromCard:(BRZContentCardRaw *)card
                         atIndex:(NSInteger)index;

@end

@implementation CardsInfoViewController

- (instancetype)initWithCards:(NSArray<BRZContentCardRaw *> *)cards {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    NSMutableArray *sections = [NSMutableArray array];
    for (NSInteger i = 0; i < cards.count; ++i) {
      BRZContentCardRaw *card = cards[i];
      [sections addObject:[CardsInfoViewController cardSectionFromCard:card
                                                               atIndex:i]];
    }
    self.sections = [sections copy];

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

+ (Section *)cardSectionFromCard:(BRZContentCardRaw *)card
                         atIndex:(NSInteger)index {
  NSMutableArray *fields = [NSMutableArray array];

  switch (card.type) {
  case BRZContentCardRawTypeClassic:
    [fields addObject:[Field fieldWithName:@"type" value:@"classic"]];
    break;
  case BRZContentCardRawTypeBanner:
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
                                   value:@(card.useWebView)]];
  [fields addObject:[Field fieldWithName:@"viewed" value:@(card.viewed)]];
  [fields addObject:[Field fieldWithName:@"dismissible"
                                   value:@(card.dismissible)]];
  [fields addObject:[Field fieldWithName:@"removed" value:@(card.removed)]];
  [fields addObject:[Field fieldWithName:@"pinned" value:@(card.pinned)]];
  [fields addObject:[Field fieldWithName:@"clicked" value:@(card.clicked)]];
  [fields addObject:[Field fieldWithName:@"test" value:@(card.test)]];
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
