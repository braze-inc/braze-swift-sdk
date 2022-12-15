@import Foundation;

#define LogUnimplemented() brzLogUnimplemented(_cmd, [self class]);

#define LogUnimplementedMessage(M) brzLogUnimplementedMessage(M, _cmd, [self class]);

void brzLogUnimplemented(SEL selector, Class class);

void brzLogUnimplementedMessage(NSString *message, SEL selector, Class class);
