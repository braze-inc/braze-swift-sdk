#import "AppDelegate.h"
#import "CardsInfoViewController.h"

@import BrazeKit;

@interface AppDelegate ()

// The subscription needs to be retained to be active.
@property(strong, nonatomic) BRZCancellable *cardsSubscription;

@end

@implementation AppDelegate

#pragma mark - Lifecycle

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Setup Braze
  BRZConfiguration *configuration =
      [[BRZConfiguration alloc] initWithApiKey:brazeApiKey
                                      endpoint:brazeEndpoint];
  configuration.logger.level = BRZLoggerLevelInfo;
  Braze *braze = [[Braze alloc] initWithConfiguration:configuration];
  AppDelegate.braze = braze;

  [self.window makeKeyAndVisible];
  return YES;
}

#pragma mark - AppDelegate.braze

static Braze *_braze = nil;

+ (Braze *)braze {
  return _braze;
}

+ (void)setBraze:(Braze *)braze {
  _braze = braze;
}

#pragma mark - Displaying Content Cards

- (void)printCurrentContentCards {
  // Print all the cards
  NSLog(@"%@", AppDelegate.braze.contentCards.cards);

  BRZContentCardRaw *cardRaw = AppDelegate.braze.contentCards.cards.firstObject;
  if (cardRaw == nil) {
    return;
  }

  // Access the `extras` dictionary / `url`:

  NSLog(@"extras: %@", cardRaw.extras);
  NSLog(@"url: %@", cardRaw.url);

  // Access the `title` / `image`

  if (cardRaw.title != nil) {
    NSLog(@"title: %@", cardRaw.title);
  }

  if (cardRaw.image != nil) {
    NSLog(@"image: %@", cardRaw.image);
  }

  // A wrapper / compatibility representation of the card is accessible via
  // `-json`.
  NSData *jsonData = [cardRaw json];
  NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                               encoding:NSUTF8StringEncoding];
  if (jsonString != nil) {
    NSLog(@"%@", jsonString);
  }
}

- (void)refreshContentCards {
  [AppDelegate.braze.contentCards
      requestRefreshWithCompletion:^(
          NSArray<BRZContentCardRaw *> *_Nullable cards,
          NSError *_Nullable error) {
        NSLog(@"cards: %@", cards);
        NSLog(@"error: %@", error);
      }];
}

- (void)subscribeToContentCardsUpdates {
  self.cardsSubscription = [AppDelegate.braze.contentCards
      subscribeToUpdates:^(NSArray<BRZContentCardRaw *> *_Nonnull cards) {
        NSLog(@"cards: %@", cards);
      }];
}

- (void)cancelContentCardsUpdatesSubscription {
  [self.cardsSubscription cancel];
}

- (void)presentContentCardsInfoViewController {
  CardsInfoViewController *viewController = [[CardsInfoViewController alloc]
      initWithCards:AppDelegate.braze.contentCards.cards];
  UINavigationController *navigationController = [[UINavigationController alloc]
      initWithRootViewController:viewController];
  [self.window.rootViewController presentViewController:navigationController
                                               animated:YES
                                             completion:nil];
}

@end
