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

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

/**
 *  A completion handler block for a `JSQLocationMediaItem`. See `setLocation: withCompletionHandler:`.
 */
typedef void (^JSQLocationMediaItemCompletionBlock)(void);


#import "JSQMediaItem.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  The `JSQLocationMediaItem` class is a concrete `JSQMediaItem` subclass that implements the `JSQMessageMediaData` protocol
 *  and represents a location media message. An initialized `JSQLocationMediaItem` object can be passed
 *  to a `JSQMediaMessage` object during its initialization to construct a valid media message object.
 *  You may wish to subclass `JSQLocationMediaItem` to provide additional functionality or behavior.
 */
@interface JSQLocationMediaItem : JSQMediaItem <JSQMessageMediaData, MKAnnotation, NSCoding, NSCopying>

/**
 *  The coordinate of the location property.
 */
@property (readonly, nonatomic) CLLocationCoordinate2D coordinate;

/**
 *  Initializes and returns a location media item object having the given location.
 *
 *  @param location The location for the media item. This value may be `nil`.
 *
 *  @return An initialized `JSQLocationMediaItem` if successful, `nil` otherwise.
 *
 *  @discussion If the location data must be dowloaded from the network,
 *  you may initialize a `JSQLocationMediaItem` object with a `nil` location.
 *  Once the location data has been retrieved, you can then set the location property
 *  using `setLocation: withCompletionHandler:`
 */
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)buildMapImageWithCoordinate:(CLLocationCoordinate2D)coordinate completion:(void (^)(UIImage * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
