#import "InAppMessageInfoViewController.h"

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

#pragma mark - InAppMessageInfoViewController

@interface InAppMessageInfoViewController ()

@property(strong, nonatomic) NSArray<Section *> *sections;

+ (NSArray<Section *> *)messageSectionsFromMessage:
    (BRZInAppMessageRaw *)message;

@end

@implementation InAppMessageInfoViewController

- (instancetype)initWithMessage:(BRZInAppMessageRaw *)message {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.sections =
        [InAppMessageInfoViewController messageSectionsFromMessage:message];

    self.title = @"In-App Message Info";

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

#pragma mark - Helpers

+ (NSArray<Section *> *)messageSectionsFromMessage:
    (BRZInAppMessageRaw *)message {
  NSMutableArray *fields = [NSMutableArray array];

  switch (message.type) {
  case BRZInAppMessageRawTypeSlideup:
    [fields addObject:[Field fieldWithName:@"type" value:@"slideup"]];
    break;
  case BRZInAppMessageRawTypeModal:
    [fields addObject:[Field fieldWithName:@"type" value:@"modal"]];
    break;
  case BRZInAppMessageRawTypeFull:
    [fields addObject:[Field fieldWithName:@"type" value:@"full"]];
    break;
  case BRZInAppMessageRawTypeHtmlFull:
    [fields addObject:[Field fieldWithName:@"type" value:@"htmlFull"]];
    break;
  case BRZInAppMessageRawTypeHtml:
    [fields addObject:[Field fieldWithName:@"type" value:@"html"]];
    break;
  default:
    break;
  }

  switch (message.clickAction) {
  case BRZInAppMessageRawClickActionNone:
    [fields addObject:[Field fieldWithName:@"clickAction" value:@"none"]];
    break;
  case BRZInAppMessageRawClickActionNewsFeed:
    [fields addObject:[Field fieldWithName:@"clickAction" value:@"newsFeed"]];
    break;
  case BRZInAppMessageRawClickActionURL:
    [fields addObject:[Field fieldWithName:@"clickAction" value:@"uri"]];
    break;
  default:
    break;
  }

  [fields addObject:[Field fieldWithName:@"uri" value:message.url]];
  [fields addObject:[Field fieldWithName:@"useWebView"
                                   value:@(message.useWebView)]];

  switch (message.messageClose) {
  case BRZInAppMessageRawCloseSwipe:
    [fields addObject:[Field fieldWithName:@"messageClose" value:@"swipe"]];
    break;
  case BRZInAppMessageRawCloseAutoDismiss:
    [fields addObject:[Field fieldWithName:@"messageClose"
                                     value:@"autoDismiss"]];
    break;
  default:
    break;
  }

  switch (message.orientation) {
  case BRZInAppMessageRawOrientationAny:
    [fields addObject:[Field fieldWithName:@"orientation" value:@"any"]];
    break;
  case BRZInAppMessageRawOrientationPortrait:
    [fields addObject:[Field fieldWithName:@"orientation" value:@"portrait"]];
    break;
  case BRZInAppMessageRawOrientationLandscape:
    [fields addObject:[Field fieldWithName:@"orientation" value:@"landscape"]];
    break;
  default:
    break;
  }

  [fields addObject:[Field fieldWithName:@"message" value:message.message]];
  [fields addObject:[Field fieldWithName:@"header" value:message.header]];
  [fields addObject:[Field fieldWithName:@"messageTextAlignment"
                                   value:@(message.messageTextAlignment)]];
  [fields addObject:[Field fieldWithName:@"headerTextAlignment"
                                   value:@(message.headerTextAlignment)]];
  [fields addObject:[Field fieldWithName:@"imageUri" value:message.imageURL]];
  [fields addObject:[Field fieldWithName:@"icon" value:message.icon]];
  [fields addObject:[Field fieldWithName:@"duration"
                                   value:@(message.duration)]];
  [fields addObject:[Field fieldWithName:@"themes" value:message.themes]];
  [fields addObject:[Field fieldWithName:@"textColor"
                                   value:message.textColor]];
  [fields addObject:[Field fieldWithName:@"headerTextColor"
                                   value:message.headerTextColor]];
  [fields addObject:[Field fieldWithName:@"iconColor"
                                   value:message.iconColor]];
  [fields addObject:[Field fieldWithName:@"iconBackgroundColor"
                                   value:message.iconBackgroundColor]];
  [fields addObject:[Field fieldWithName:@"backgroundColor"
                                   value:message.backgroundColor]];
  [fields addObject:[Field fieldWithName:@"frameColor"
                                   value:message.frameColor]];
  [fields addObject:[Field fieldWithName:@"closeButtonColor"
                                   value:message.closeButtonColor]];
  [fields addObject:[Field fieldWithName:@"buttons" value:message.buttons]];

  switch (message.imageStyle) {
  case BRZInAppMessageRawImageStyleTop:
    [fields addObject:[Field fieldWithName:@"imageStyle" value:@"top"]];
    break;
  case BRZInAppMessageRawImageStyleGraphic:
    [fields addObject:[Field fieldWithName:@"imageStyle" value:@"graphic"]];
    break;
  default:
    break;
  }

  switch (message.slideFrom) {
  case BRZInAppMessageRawSlideFromTop:
    [fields addObject:[Field fieldWithName:@"slideFrom" value:@"top"]];
    break;
  case BRZInAppMessageRawSlideFromBottom:
    [fields addObject:[Field fieldWithName:@"slideFrom" value:@"bottom"]];
    break;
  default:
    break;
  }

  [fields addObject:[Field fieldWithName:@"animateIn"
                                   value:@(message.animateIn)]];
  [fields addObject:[Field fieldWithName:@"animateOut"
                                   value:@(message.animateOut)]];

  NSData *extrasData = [NSJSONSerialization dataWithJSONObject:message.extras
                                                       options:0
                                                         error:nil];
  NSString *extrasString = [[NSString alloc] initWithData:extrasData
                                                 encoding:NSUTF8StringEncoding];
  [fields addObject:[Field fieldWithName:@"extras" value:@""]];
  [fields addObject:[Field fieldWithName:extrasString value:@"" indentation:1]];

  [fields addObject:[Field fieldWithName:@"baseURL" value:message.baseURL]];
  [fields addObject:[Field fieldWithName:@"assetURLs" value:message.assetURLs]];
  [fields addObject:[Field fieldWithName:@"isControl"
                                   value:@(message.isControl)]];

  Section *section = [[Section alloc] init];
  section.name = @"message";
  section.fields = [fields copy];

  return @[ section ];
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
