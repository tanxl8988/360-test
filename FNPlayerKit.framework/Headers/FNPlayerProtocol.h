//
//  FNPlayerProtocol.h
//  FNPlayerKit
//
//  Created by DevinLai on 2016/7/13.
//  Copyright © 2016年 DevinLai. All rights reserved.
//

typedef NS_ENUM(NSInteger, FN360ModeInteractive) {
    FN360ModeInteractiveTouch,
    FN360ModeInteractiveMotion,
    FN360ModeInteractiveMotionWithTouch,
    FN360ModeInteractiveCount,
};

typedef NS_ENUM(NSInteger, FN360ModeDisplay) {
    FN360ModeDisplayNormal,
    FN360ModeDisplayGlass,
    FN360ModeDisplaySegment2,
    FN360ModeDisplaySegment4,
    FN360ModeDisplayCount,
};

typedef NS_ENUM(NSInteger, FN360ModeProjection) {
    FN360ModeProjectionSphere,
    FN360ModeProjectionSphereDown,
    FN360ModeProjectionSphereFront,
    FN360ModeProjectionSphereUpsideDown,
    FN360ModeProjectionSphereDownUpsideDown,
    FN360ModeProjectionSphereFrontUpsideDown,
    FN360ModeProjectionFullSphere,
    FN360ModeProjectionFullSphereDown,
    FN360ModeProjectionFullSphereFront,
    FN360ModeProjectionBallFullSphere,
    FN360ModeProjectionBallFullSphereDown,
    FN360ModeProjectionBallFullSphereFront,
    FN360ModeProjectionDome180Down,
    FN360ModeProjectionDome180Upper,
    FN360ModeProjectionDome230Upper,
    FN360ModeProjectionDome230Down,
    FN360ModeProjectionDome230Front,
    FN360ModeProjectionDome2Segment,
    FN360ModeProjectionDome4Segment,
    FN360ModeProjectionDomeBallUpper,
    FN360ModeProjectionDomeBallDualUpper,
    FN360ModeProjectionDomeBallFront,
    FN360ModeProjectionDomeBallDualFront,
    FN360ModeProjectionDomeBallDown,
    FN360ModeProjectionDomeBallDualDown,
    FN360ModeProjectionDome230DualUpper,
    FN360ModeProjectionDome230DualDown,
    FN360ModeProjectionDome230DualFront,
    FN360ModeProjectionStereoSphere,
    FN360ModeProjectionPlaneFit,
    FN360ModeProjectionPlaneCrop,
    FN360ModeProjectionPlaneFull,
    FN360ModeProjectionAsteroid,
    FN360ModeProjectionCount,
};

extern NSString *_Nonnull const FNPlayerDidPlayToEndTimeNotification;
extern NSString *_Nonnull const FNPlayerPlaybackStalledNotification;

// notification userInfo key
extern NSString *_Nonnull const FNPlayerFailedToPlayToEndTimeErrorKey;   // NSError
extern NSString *_Nonnull const FNPlayerPlaybackDidFinishReasonUserInfoKey;
extern NSString *_Nonnull const FNPlayerPlayerPreparedNotification;

//notification shut down
extern NSString *_Nonnull const FNPlayerDidShutDownNotification;

#ifndef FNPlayerProtocol_h
#define FNPlayerProtocol_h
@import UIKit;
@import CoreMedia;

@protocol FNPlayerDelegate;

@protocol FNPlayerProtocol <NSObject>

@required

/*!
	@method			play
	@abstract		Begins playback of the current item.
	@discussion		Same as setting rate to 1.0.
 */
- (void) play;

/*!
	@method			pause
	@abstract		Pauses playback.
	@discussion		Same as setting rate to 0.0.
 */
- (void) pause;

- (void) setMirror:(BOOL)mirror;

@optional
/* current movie buffer status */
@property (nonatomic, strong, nonnull) NSArray<NSValue*>* loadedTimeRanges; // CMTimeRange inside

/* indicates the current rate of playback; 0.0 means "stopped", 1.0 means "play at the natural rate" */
@property (nonatomic) float rate;    //isPlaying state

- (void) stop;

/* show video controller, default = YES, set NO to disable controller */
@property (nonatomic) BOOL enableVideoController;

@property (nonatomic) BOOL prepared;

/* controller hidden time in millisecond, set 0 to use default value(3000 ms) */
@property (nonatomic) CGFloat hiddenTimeInMinisecond;

/* playBackVolume,  0.0 ~ 1.0, 0 for mute, or no audio support */
@property (nonatomic) float playBackVolume;

/// true = drop start, false = drop end.
@property (copy) void (^ _Nullable dropFramesObserver)(BOOL);

/*!
	@method			addPeriodicTimeObserverForInterval:queue:usingBlock:
	@abstract		Periodic to notify user current time.
	@param			interval - notify period
    @param          queue - notify queue
    @param          block - notify callback.
	@discussion		set block to nil when you do not need it.
 */
- (void)addPeriodicTimeObserverForInterval:(CMTime)interval queue:(nullable dispatch_queue_t)queue usingBlock:(void (^ _Nullable)(CMTime))block;

/*!
	@method			currentTime
	@abstract		get current time.
	@discussion		time in second.
 */
- (CMTime)currentTime;

/*!
	@method			captureCurrentFrame
	@abstract		capture current frame in player view.
    @return         image of current view
	@discussion		image size depends on player.view.bounds.
 */
- (nullable UIImage*) captureCurrentFrame;

/*!
	@method			seekToTime:
	@abstract		seek Player time.
	@param			time - seek target
 */
- (void) seekToTime:(CMTime)time;

/*!
	@method			resolution
	@abstract		Resolution info in metaData.
	@discussion		Ex: 1920x1080.
 */
- (nullable NSString*) resolution;

/*!
	@method			duration
	@abstract		duration info in metaData.
	@discussion		Unit in second.
 */
- (CMTime) duration;

/*!
   @method          vfps
   @abstract        Video output frames per second.
*/
- (float)vfps;

@end


@protocol FN360PlayerProtocol <NSObject>
/*!
 * VR DisplayMode
 * support for both VR player and VR Image.
 */
@property (nonatomic, assign) FN360ModeDisplay     displayMode;

/*!
 * VR ProjectionMode
 * support for both VR player and VR Image.
 */
@property (nonatomic, assign) FN360ModeProjection  projectionMode;

/*!
 * VR InteractiveMode
 * support for both VR player and VR Image.
 */
@property (nonatomic, assign) FN360ModeInteractive interactiveMode;

/*!
 @method        dragDistanceX: distanceY:
 @abstract      Control vr player display area.
 @discussion    x > 0 for pan gesture direction right, y > 0 for pan gesture down.
 */
- (void) dragDistanceX:(float)distanceX distanceY:(float)distanceY;

- (void) setFullScreen:(BOOL)full;

@end
#endif /* FNPlayerProtocol_h */
