#import "BRZLog.h"

void brzLogUnimplemented(SEL selector, Class class) {
  NSLog(@"[BrazeKitCompat] '%@.%@' is not implemented.",
        NSStringFromClass(class), NSStringFromSelector(selector));
}

void brzLogUnimplementedMessage(NSString *message, SEL selector, Class class) {
  NSLog(@"[BrazeKitCompat] '%@.%@' is not implemented. %@",
        NSStringFromClass(class), NSStringFromSelector(selector), message);
}
