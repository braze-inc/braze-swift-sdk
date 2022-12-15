#import "ABKSDWebImageProxy.h"
#import "../BRZLog.h"
#import "ABKSDWebImageProxy+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@implementation ABKSDWebImageProxy

+ (void)setImageForView:(UIImageView *)imageView
    showActivityIndicator:(BOOL)showActivityIndicator
                  withURL:(NSURL *)imageURL
         imagePlaceHolder:(UIImage *)placeHolder
                completed:(void (^)(UIImage *_Nullable, NSError *_Nullable,
                                    NSInteger, NSURL *_Nullable))completion {
  LogUnimplemented();
}

+ (void)loadImageWithURL:(NSURL *)url
                 options:(NSInteger)options
               completed:(void (^)(UIImage *_Nonnull, NSData *_Nonnull,
                                   NSError *_Nonnull, NSInteger, BOOL,
                                   NSURL *_Nonnull))completion {
  LogUnimplemented();
}

+ (void)diskImageExistsForURL:(NSURL *)url
                    completed:(void (^)(BOOL))completion {
  LogUnimplemented();
}

+ (NSString *)cacheKeyForURL:(NSURL *)url {
  LogUnimplemented();
  return nil;
}

+ (void)removeSDWebImageForKey:(NSString *)key {
  LogUnimplemented();
}

+ (UIImage *)imageFromCacheForKey:(NSString *)key {
  LogUnimplemented();
  return nil;
}

+ (void)clearSDWebImageCache {
  LogUnimplemented();
}

+ (BOOL)isSupportedSDWebImageVersion {
  LogUnimplemented();
  return NO;
}

@end

#pragma clang diagnostic pop
