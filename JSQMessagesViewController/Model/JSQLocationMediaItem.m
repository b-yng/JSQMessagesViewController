//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQLocationMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"


@interface JSQLocationMediaItem ()
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) UIImage *cachedMapSnapshotImage;
@property (strong, nonatomic) UIImageView *cachedMapImageView;
@end


@implementation JSQLocationMediaItem

#pragma mark - Initialization

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        [self setCoordinate:coordinate withCompletionHandler:nil];
    }
    return self;
}

- (void)clearCachedMediaViews
{
    [super clearCachedMediaViews];
    _cachedMapImageView = nil;
}

#pragma mark - Setters

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedMapSnapshotImage = nil;
    _cachedMapImageView = nil;
}

#pragma mark - Map snapshot

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate withCompletionHandler:(JSQLocationMediaItemCompletionBlock)completion
{
    _coordinate = coordinate;
    _cachedMapSnapshotImage = nil;
    _cachedMapImageView = nil;
    
    [self buildMapImageWithCoordinate:coordinate completion:^(UIImage *image) {
        self.cachedMapSnapshotImage = image;
        if (completion) completion();
    }];
}

- (void)buildMapImageWithCoordinate:(CLLocationCoordinate2D)coordinate completion:(void (^)(UIImage *))completion {
    
}

//- (void)createMapViewSnapshotForLocation:(CLLocation *)location
//                        coordinateRegion:(MKCoordinateRegion)region
//                   withCompletionHandler:(JSQLocationMediaItemCompletionBlock)completion
//{
//    NSParameterAssert(location != nil);
//
//    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
//    options.region = region;
//    options.size = [self mediaViewDisplaySize];
//    options.scale = [UIScreen mainScreen].scale;
//
//    MKMapSnapshotter *snapShotter = [[MKMapSnapshotter alloc] initWithOptions:options];
//
//    [snapShotter startWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//              completionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
//                  if (snapshot == nil) {
//                      NSLog(@"%s Error creating map snapshot: %@", __PRETTY_FUNCTION__, error);
//                      return;
//                  }
//
//                  MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:nil];
//                  CGPoint coordinatePoint = [snapshot pointForCoordinate:location.coordinate];
//                  UIImage *image = snapshot.image;
//
//                  coordinatePoint.x += pin.centerOffset.x - (CGRectGetWidth(pin.bounds) / 2.0);
//                  coordinatePoint.y += pin.centerOffset.y - (CGRectGetHeight(pin.bounds) / 2.0);
//
//                  UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
//                  {
//                      [image drawAtPoint:CGPointZero];
//                      [pin.image drawAtPoint:coordinatePoint];
//                      self.cachedMapSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
//                  }
//                  UIGraphicsEndImageContext();
//
//                  if (completion) {
//                      dispatch_async(dispatch_get_main_queue(), completion);
//                  }
//              }];
//}

#pragma mark - JSQMessageMediaData protocol

- (UIView *)mediaView
{
    if (self.cachedMapSnapshotImage == nil) {
        return nil;
    }
    
    if (self.cachedMapImageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.cachedMapSnapshotImage];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        self.cachedMapImageView = imageView;
    }
    
    return self.cachedMapImageView;
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (![super isEqual:object]) {
        return NO;
    }
    
    JSQLocationMediaItem *locationItem = (JSQLocationMediaItem *)object;
    
    return self.coordinate.latitude == locationItem.coordinate.latitude &&
    self.coordinate.longitude == locationItem.coordinate.longitude;
}

- (NSUInteger)hash
{
    return super.hash ^ @(self.coordinate.longitude).hash ^ @(self.coordinate.latitude).hash;
}


#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CLLocationDegrees longitude = [aDecoder decodeDoubleForKey:@"longitude"];
        CLLocationDegrees latitude = [aDecoder decodeDoubleForKey:@"latitude"];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        [self setCoordinate:coordinate withCompletionHandler:nil];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeDouble:self.coordinate.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.coordinate.longitude forKey:@"longitude"];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQLocationMediaItem *copy = [[[self class] allocWithZone:zone] initWithCoordinate:self.coordinate];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end
