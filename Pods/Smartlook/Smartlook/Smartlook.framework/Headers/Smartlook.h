//
//  Smartlook.h
//  Smartlook iOS SDK 1.2.0
//
//  Copyright © 2019 Smartsupp.com, s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <WebKit/WebKit.h>

#import "Smartlook_Deprecated.h"
#import "UIView+Smartlook.h"
#import "Smartlook_Version.h"

NS_SWIFT_NAME(Smartlook.SensitiveData)
/**
 Convenience protocol to "flag" classes that present sensitive data.
 */
@protocol SLSensitiveData
@end

NS_SWIFT_NAME(Smartlook.NotSensitiveData)
/**
 Convenience protocol to "flag" classes that present nonsensitive data.
 */
@protocol SLNonSensitiveData
@end

// Smartlook SDK. To use, call "startWithApiKey:" method from "applicationDidFinishLaunching:withOptions:" in your AppDelegate class

/// Smartlook public interface
@interface Smartlook (PublicInterface)

// MARK: Setup

NS_SWIFT_NAME(Smartlook.SetupOptionKey)
typedef NSString * SLSetupOptionKey NS_TYPED_ENUM;
extern SLSetupOptionKey const _Nonnull SLSetupOptionFramerateKey NS_SWIFT_NAME(framerate);
extern SLSetupOptionKey const _Nonnull SLSetupOptionEnableCrashyticsKey NS_SWIFT_NAME(enableCrashytics);
extern SLSetupOptionKey const _Nonnull SLSetupOptionUseAdaptiveFramerateKey NS_SWIFT_NAME(useAdaptiveFramerate);
extern SLSetupOptionKey const _Nonnull SLSetupOptionAnalyticsOnlyKey NS_SWIFT_NAME(analyticsOnly);
//
extern SLSetupOptionKey const _Nonnull SLSetupOptionRenderingModeKey NS_SWIFT_NAME(renderingMode);
extern SLSetupOptionKey const _Nonnull SLSetupOptionRenderingModeOptionsKey NS_SWIFT_NAME(renderingModeOptions);
//
extern SLSetupOptionKey const _Nonnull SLSetupOptionStartNewSessionKey NS_SWIFT_NAME(startNewSession);
extern SLSetupOptionKey const _Nonnull SLSetupOptionStartNewSessionAndResetUserKey NS_SWIFT_NAME(startNewSessionAndResetUser);
//
extern SLSetupOptionKey const _Nonnull SLSetupOptionRequestHeaderFiltersKey NS_SWIFT_NAME(requestHeaderFilters);
extern SLSetupOptionKey const _Nonnull SLSetupOptionURLPatternFiltersKey NS_SWIFT_NAME(urlPatternFilters);
extern SLSetupOptionKey const _Nonnull SLSetupOptionURLQueryParamFiltersKey NS_SWIFT_NAME(urlQueryParamFilters);

extern SLSetupOptionKey const _Nonnull SLSetupOptionAnalyticsOnlyKey NS_SWIFT_NAME(analyticsOnly) DEPRECATED_MSG_ATTRIBUTE("use a suitable combination of rendering and event tracking mode instead.");

NS_SWIFT_NAME(Smartlook.RenderingMode)
typedef NSString * SLRenderingMode NS_TYPED_ENUM;
extern SLRenderingMode const _Nonnull SLRenderingModeNative NS_SWIFT_NAME(native);
extern SLRenderingMode const _Nonnull SLRenderingModeWireframe NS_SWIFT_NAME(wireframe);
extern SLRenderingMode const _Nonnull SLRenderingModeNoRendering NS_SWIFT_NAME(noRendering);

NS_SWIFT_NAME(Smartlook.RenderingModeOption)
typedef NSString * SLRenderingModeOption NS_TYPED_ENUM;
extern SLRenderingModeOption const _Nonnull SLRenderingModeOptionNone NS_SWIFT_NAME(none);
extern SLRenderingModeOption const _Nonnull SLRenderingModeOptionColorWireframe NS_SWIFT_NAME(colorWireframe);
extern SLRenderingModeOption const _Nonnull SLRenderingModeOptionBlueprintWireframe NS_SWIFT_NAME(blueprintWireframe);
extern SLRenderingModeOption const _Nonnull SLRenderingModeOptionIconBlueprintWireframe NS_SWIFT_NAME(iconBlueprintWireframe);

NS_SWIFT_NAME(Smartlook.EventTrackingMode)
typedef NSString * SLEventTrackingMode NS_TYPED_ENUM;
extern SLEventTrackingMode const _Nonnull SLEventTrackingModeFullTracking NS_SWIFT_NAME(fullTracking);
extern SLEventTrackingMode const _Nonnull SLEventTrackingModeIgnoreUserInteractionEvents NS_SWIFT_NAME(ignoreUserInteractionEvents);
extern SLEventTrackingMode const _Nonnull SLEventTrackingModeNoTracking NS_SWIFT_NAME(noTracking);

extern NSNotificationName const _Nonnull SLDashboardSessionURLChangedNotification NS_SWIFT_NAME(Smartlook.dashboardSessionURLChanged);
extern NSNotificationName const _Nonnull SLDashboardVisitorURLChangedNotification NS_SWIFT_NAME(Smartlook.dashboardVisitorURLChanged);

/**
 Setup Smartlook.
 
 Call this method once in your `applicationDidFinishLaunching:withOptions:`.
 
 - Attention: This method initializes Smartlook SDK, but does not start recording. To start recording, call `startRecording` method.
 
 @param key The application (project) specific SDK key, available in your Smartlook dashboard.
 */
+(void)setupWithKey:(nonnull NSString *)key;

/**
 Setup Smartlook.
 
 Call this method once in your `applicationDidFinishLaunching:withOptions:`.

 - Attention: This method initializes Smartlook SDK, but does not start recording. To start recording, call `startRecording` method.
 
 @param key The application (project) specific SDK key, available in your Smartlook dashboard.
 @param options (optional) Startup options.
 
 `SLFramerateOptionKey` (Swift: `Smartlook.framerateOptionKey`) NSNumber, custom recording framerate.
 */
+(void)setupWithKey:(nonnull NSString *)key options:(nullable NSDictionary<SLSetupOptionKey,id> *)options NS_SWIFT_NAME(setup(key:options:));

// MARK: Reset session

/**
Reset Session

This method resets the current session by implicitelly starting a new one. Optionally, it also resets the used.

- Attention: Each session is tied to a particular user, i.e., to reset user, new session must be created as a consequence.

@param resetUser Indicates, whether new session starts with new user, too.
*/
+ (void)resetSessionAndUser:(BOOL)resetUser NS_SWIFT_NAME(resetSession(resetUser:));

// MARK: Start/Stop Recording

/** Starts video and events recording.
 */
+ (void)startRecording;

/** Stops video and events recording.
 */
+ (void)stopRecording;

/** Current video and events recording state.
 */
+ (BOOL)isPaused;

/** Current video and events recording state.
 */
+ (BOOL)isRecording;


// MARK: Switch Rendering Mode

/**
 Switches the rendering mode. This can be done any time, no need to stop or start recording for it. Rendering mode can be also set as a setup option. If none is explicitly provided, `native`, the most universal mode, is used.
 */
+ (void)setRenderingModeTo:(nonnull SLRenderingMode)renderingMode NS_SWIFT_NAME(setRenderingMode(to:));

/**
 Switches the rendering mode with optional option. This can be done any time, no need to stop or start recording for it. Rendering mode can be also set as a setup option. If none is explicitly provided, `native`, the most universal mode, is used.
 */
+ (void)setRenderingModeTo:(nonnull SLRenderingMode)renderingMode withOption:(nullable SLRenderingModeOption)renderingModeOption NS_SWIFT_NAME(setRenderingMode(to:option:));

/// Returns the current rendering mode.
+ (_Nonnull SLRenderingMode)currentRenderingMode;

/// Returns current rendering mode option
+ (_Nullable SLRenderingModeOption)currentRenderingModeOption;


// MARK: Events Tracking Mode

/**
 Switches the event tracking mode.
 
 This can be done any time, no need to stop or start recording for it. Event tracking mode can be also set as a setup option. If none is explicitly provided, `fullTracking` is used.
 */
+ (void)setEventTrackingModeTo:(nonnull SLEventTrackingMode)eventTrackingMode NS_SWIFT_NAME(setEventTrackingMode(to:));

// Returns the currently set event tracking mode.
+ (nonnull SLEventTrackingMode)currentEventTrackingMode;


// MARK: Custom Events

/**
 Records timestamped custom event with optional properties.
 
 @param eventName Name that identifies the event.
 @param props Optional dictionary with additional information. Non String values will be stringlified.
 */
+ (void)trackCustomEventWithName:(nonnull NSString*)eventName props:(nullable NSDictionary<NSString*, NSString*>*)props NS_SWIFT_NAME(trackCustomEvent(name:props:));

/**
 Start timer for custom event.
 
 This method does not record an event. It is the subsequent `stopTimedEvent` or `cancelTimedCustomEvent` call that refers to the `id` returned by this call that does..
 
 In the resulting event, the property dictionaries of `start` and `record` are merged (the `record` values override the `start` ones if the key is the same), and a `duration` property is added to them.
 
 @param eventName Name of the event.
 @param props Optional dictionary with additional information.  Non String values will be stringlified.
 @return return opaque event identifier
 */
+ (id _Nonnull)startTimedCustomEventWithName:(nonnull NSString*)eventName props:(nullable NSDictionary<NSString*, NSString*>*)props NS_SWIFT_NAME(startTimedCustomEvent(name:props:));


/**
 Stops custom times event.
 
 This method ends the custom timed event created by a `startTimedCustomEvent` call. The event is identified by an opaque event reference returned by the respective `startTimedCustomEvent`.

 In the resulting event, the property dictionaries of `start` and `record` are merged (the `record` values override the `start` ones if the key is the same), and a `duration` property is added to them.
 
 @param eventId event identifier as returned by the corresponding `startTimedCustomEvent`
 @param props Optional dictionary with additional information.  Non String values will be stringlified.
 */
+ (void)trackTimedCustomEventWithEventId:(id _Nonnull)eventId props:(nullable NSDictionary<NSString*, NSString*>*)props NS_SWIFT_NAME(trackTimedCustomEvent(eventId:props:));

/**
 Stops custom times event.
 
 This method ends the custom timed event created by a `startTimedCustomEvent` call. The event is identified by an opaque event reference returned by the respective `startTimedCustomEvent`.
 
 In the resulting event, the property dictionaries of `start` and `record` are merged (the `record` values override the `start` ones if the key is the same), and a `duration` property is added to them.
 
 @param eventId event identifier as returned by the corresponding `startTimedCustomEvent`
 @param reason Optional string that describes the reason for the cancelation.
 @param props Optional dictionary with additional information.  Non String values will be stringlified.
 */
+ (void)trackTimedCustomEventCancelWithEventId:(id _Nonnull)eventId reason:(NSString *_Nullable)reason props:(nullable NSDictionary<NSString*, NSString*>*)props NS_SWIFT_NAME(trackTimedCustomEventCancel(eventId:reason:props:));


// MARK: - Session and Global Event Properties

/** Set the app's user identifier.
 @param userIdentifier The application-specific user identifier.
 */
+ (void)setUserIdentifier:(nullable NSString*)userIdentifier;


NS_SWIFT_NAME(Smartlook.PropertyOption)
/**
 Smartlook property options

 - SLPropertyOptionDefaults: the default value
 - SLPropertyOptionImmutable: the property is immutable. To change it, remove it first.
 */
typedef NS_OPTIONS(NSUInteger, SLPropertyOption) {
    SLPropertyOptionDefaults    = 0,
    SLPropertyOptionImmutable   = 1 << 0
};

/**
 Custom session properties. You will see these properties in the Dashboard at Visitor details.

 @param value the property value
 @param name the property name
 */
+ (void)setSessionPropertyValue:(nonnull NSString *)value forName:(nonnull NSString *)name NS_SWIFT_NAME(setSessionProperty(value:forName:));

/**
 Custom session properties. You will see these properties in the Dashboard at Visitor details.

 @param value the property value
 @param name the property name
 @param options how the property is managed
 */
+ (void)setSessionPropertyValue:(nonnull NSString *)value forName:(nonnull NSString *)name withOptions:(SLPropertyOption)options NS_SWIFT_NAME(setSessionProperty(value:forName:options:));

/**
 Removes custom session property.

 @param name the property name
 */
+ (void)removeSessionPropertyForName:(nonnull NSString *)name NS_SWIFT_NAME(removeSessionProperty(forName:));
/**
 Removes all the custom session properties.
 */
+ (void)clearSessionProperties;


/**
 Global event properties are sent with every event.

 @param value the property value
 @param name the property name
 */
+ (void)setGlobalEventPropertyValue:(nonnull NSString *)value forName:(nonnull NSString *)name NS_SWIFT_NAME(setGlobalEventProperty(value:forName:));
/**
 Global event properties are sent with every event.

 @param value  the property value
 @param name  the property name
 @param options  how the property is managed
 */
+ (void)setGlobalEventPropertyValue:(nonnull NSString *)value forName:(nonnull NSString *)name withOptions:(SLPropertyOption)options NS_SWIFT_NAME(setGlobalEventProperty(value:forName:options:));

/**
 Removes global event property so it is no longer sent with every event.

 @param name the property name
 */
+ (void)removeGlobalEventPropertyForName:(nonnull NSString *)name NS_SWIFT_NAME(removeGlobalEventProperty(forName:));
/**
 Removes all global event properties so they are no longer sent with every event.
 */
+ (void)clearGlobalEventProperties;

// MARK: - Sensitive Views

/**
 Default colour of blacklisted view overlay

 @param color overlay colour
 */
+ (void)setBlacklistedItemsColor:(nonnull UIColor *)color NS_SWIFT_NAME(setBlacklistedItem(color:));

/**
 Use to exempt a view from being ovelayed in video recording as containting sensitive data.
 
 By default, all instances of `UITextView`, `UITextField` and `WKWebView` are blacklisted.

 See online documentation for detailed blacklisting/whitelisting documentation.
 
 @param object an instance of UIView, an UIView subclass or a Protocol reference
 */
+ (void)registerWhitelistedObject:(nonnull id)object NS_SWIFT_NAME(registerWhitelisted(object:));
/**
 Use to stop whitelisting an object. Whitelisted objects are exempted from being ovelayed in video recording as containting sensitive data.
 
 By default, all instances of `UITextView`, `UITextField` and `WKWebView` are blacklisted.
 
 See online documentation for detailed blacklisting/whitelisting documentation.
 
 @param object an instance of UIView, an UIView subclass or a Protocol reference
 */
+ (void)unregisterWhitelistedObject:(nonnull id)object NS_SWIFT_NAME(unregisterWhitelisted(object:));

/**
 Add an object to the blacklist. Blacklisted objects are ovelayed in video recording..
 
 By default, all instances of `UITextView`, `UITextField` and `WKWebView` are blacklisted.
 
 See online documentation for detailed blacklisting/whitelisting documentation.
 
 @param object an instance of UIView, an UIView subclass or a Protocol reference
 */
+ (void)registerBlacklistedObject:(nonnull id)object NS_SWIFT_NAME(registerBlacklisted(object:));
/**
 Remove an object from the blacklist. Blacklisted objects are ovelayed in video recording..
 
 By default, all instances of `UITextView`, `UITextField` and `WKWebView` are blacklisted.
 
 See online documentation for detailed blacklisting/whitelisting documentation.
 
 @param object an instance of UIView, an UIView subclass or a Protocol reference
 */
+ (void)unregisterBlacklistedObject:(nonnull id)object NS_SWIFT_NAME(unregisterBlacklisted(object:));

// MARK: - Dashboard session URL
/**
 URL leading to the Dashboard player for the current Smartlook session. This URL can be access by users with the access rights to the dashboard.

 @param withTimestamp decides the URL points to the current moment in the recording
 
 @return current session recording Dashboard URL
 */
+ (nullable NSURL *)getDashboardSessionURLWithCurrentTimestamp:(BOOL)withTimestamp NS_SWIFT_NAME(getDashboardSessionURL(withCurrentTimestamp:));

/**
 URL leading to the Dashboard landing page of the current visitor. This URL can be access by users with the access rights to the dashboard.

 @return the current visitor Dashboard URL
 */
+ (nullable NSURL *)getDashboardVisitorURL;

// MARK: - Custom navigation events

 NS_SWIFT_NAME(Smartlook.NavigationEventType)
 typedef NSString * SLNavigationType NS_TYPED_ENUM;
 extern SLNavigationType const _Nonnull SLNavigationTypeEnter NS_SWIFT_NAME(enter);
 extern SLNavigationType const _Nonnull SLNavigationTypeExit NS_SWIFT_NAME(exit);
 
 + (void)trackNavigationEventWithControllerId:(nonnull NSString *)controllerId type:(nonnull SLNavigationType)type NS_SWIFT_NAME(trackNavigationEvent(withControllerId:type:));
 
@end

