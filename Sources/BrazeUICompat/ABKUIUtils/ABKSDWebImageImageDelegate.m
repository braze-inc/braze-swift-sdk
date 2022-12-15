#import "ABKSDWebImageImageDelegate.h"
#import "SDWebImage/SDWebImage.h"

@implementation ABKSDWebImageImageDelegate

- (void)setImageForView:(UIImageView *)imageView
  showActivityIndicator:(BOOL)showActivityIndicator
                withURL:(nullable NSURL *)imageURL
       imagePlaceHolder:(nullable UIImage *)placeHolder
              completed:(nullable void (^)(UIImage * _Nullable image, NSError * _Nullable error, NSInteger cacheType, NSURL * _Nullable imageURL))completion {
  if (showActivityIndicator) {
    imageView.sd_imageIndicator = SDWebImageActivityIndicator.grayIndicator;
  }
  [imageView sd_setImageWithURL:imageURL
               placeholderImage:placeHolder
                        options: (SDWebImageQueryMemoryData | SDWebImageQueryDiskDataSync)
                      completed:completion];
}

- (void)loadImageWithURL:(nullable NSURL *)url
                 options:(ABKImageOptions)options
               completed:(nullable void(^)(UIImage *image, NSData *data, NSError *error, NSInteger cacheType, BOOL finished, NSURL *imageURL))completion {
  [SDWebImageManager.sharedManager loadImageWithURL:url
                                            options:(SDWebImageOptions)options
                                           progress:nil
                                          completed:completion];
}

- (void)diskImageExistsForURL:(nullable NSURL *)url
                    completed:(nullable void (^)(BOOL isInCache))completion {
  if (url != nil) {
    [[SDImageCache sharedImageCache] diskImageExistsWithKey:url.absoluteString completion:completion];
  }
}

- (nullable UIImage *)imageFromCacheForURL:(nullable NSURL *)url {
  NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
  return [SDImageCache.sharedImageCache imageFromCacheForKey:key];
}

- (Class)imageViewClass {
  return [SDAnimatedImageView class];
}

@end
