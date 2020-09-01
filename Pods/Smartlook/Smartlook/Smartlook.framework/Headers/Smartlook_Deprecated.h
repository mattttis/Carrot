//
//  Smartlook_Deprecated.h
//  Smartlook
//
//  Created by Pavel Kroh on 24/06/2019.
//  Copyright © 2019 Smartsupp.com, s.r.o. All rights reserved.
//

#ifndef Smartlook_Deprecated_h
#define Smartlook_Deprecated_h

@interface Smartlook: NSObject

/** Starts Smartlook. This method initializes and start Smartlook SDK recording. Call this method once in your "applicationDidFinishLaunching:withOptions:".
 @param key The application (project) specific SDK key, available in your Smartlook dashboard.
 */
+ (void)startWithKey:(nonnull NSString*)key DEPRECATED_MSG_ATTRIBUTE("use `setup` and subsequent `startRecording` instead.");

/**
 Initializes and starts Smartlook. Call this method once in your "applicationDidFinishLaunching:withOptions:".
 
 @param key The application (project) specific SDK key, available in your Smartlook dashboard.
 @param framerate Screen recording framerate in fps.
 */
+ (void)startWithKey:(nonnull NSString*)key framerate:(NSInteger)framerate DEPRECATED_MSG_ATTRIBUTE("use `setup` with the framerate set as an option and subsequent `startRecording` instead.");

/** Initializes Smartlook. This method initializes Smartlook SDK without starting the recording. Call this method once in your "applicationDidFinishLaunching:withOptions:". Call `[Smartlook resumeRecording]` to start recording events and the screen.
 @param key The application (project) specific SDK key, available in your Smartlook dashboard.
 */
+ (void)initializeWithKey:(nonnull NSString*)key  DEPRECATED_MSG_ATTRIBUTE("use `setup` instead.");

/**
 Initializes Smartlook. This method initializes Smartlook SDK without starting the recording. Call this method once in your "applicationDidFinishLaunching:withOptions:". Call `[Smartlook resumeRecording]` to start recording events and the screen.
 
 @param key The application (project) specific SDK key, available in your Smartlook dashboard.
 @param framerate Screen recording framerate in fps.
 */
+ (void)initializeWithKey:(nonnull NSString*)key framerate:(NSInteger)framerate  DEPRECATED_MSG_ATTRIBUTE("use `setup` with the framerate set as in options.");

/** Marks view as sensitive. This view will not be shown in video recordings.
 @param view The view that will not be shown in video recordings
 @param overlayColor Optional overlay color which will be drawn in recordings instead of the sensitive view
 */


/** Resumes recording.
 */
+ (void)resumeRecording DEPRECATED_MSG_ATTRIBUTE("use `startRecording` instead.");

/** Pauses recording.
 */
+ (void)pauseRecording  DEPRECATED_MSG_ATTRIBUTE("use `stopRecording` instead.");


/** Records timestamped custom event with optional properties.
 @param eventName Name of the event.
 @param propertiesDictionary Optional dictionary with additional information. All values in propertiesDictionary must be NSStrings.
 */
+ (void)recordCustomEventWithEventName:(nonnull NSString*)eventName propertiesDictionary:(nullable NSDictionary<NSString*, NSString*>*)propertiesDictionary  DEPRECATED_MSG_ATTRIBUTE("use `trackCustomEvent` instead.");

/**
 Start timer for custom event.
 
 This method does not record an event. It is the subsequent `recordCustomEvent` call with the same `eventName` that does.
 
 In the resulting event, the property dictionaries of `start` and `record` are merged (the `record` values override the `start` ones if the key is the same), and a `duration` property is added to them.
 
 @param eventName Name of the event.
 @param propertiesDictionary Optional dictionary with additional information. All values in propertiesDictionary must be NSStrings.
 */
+ (void)startCustomEventWithEventName:(nonnull NSString*)eventName propertiesDictionary:(nullable NSDictionary<NSString*, NSString*>*)propertiesDictionary DEPRECATED_MSG_ATTRIBUTE("use `startCustomTimedEvent` instead.");

/** Set the app's user properties.
 @param userPropertiesDictionary The application-specific user properties dictionary. All values in userPropertiesDictionary must be NSStrings.
 */
+ (void)setUserPropertiesDictionary:(nullable NSDictionary<NSString*, NSString*>*)userPropertiesDictionary  DEPRECATED_MSG_ATTRIBUTE("use `setSessionPropertyValue` instead.");


// MARK: - Sensitive views

+ (void)markViewAsSensitive:(nonnull UIView*)view overlayColor:(nullable UIColor*)overlayColor DEPRECATED_MSG_ATTRIBUTE("use `UIView.isSensitive`, `registerBlacklistedObject` or `unregisterWhitelistedObject` instead.");

/** Unmarks view as a sensitive view.
 @param view The view that will be unmarked as a sensitive view.
 */
+ (void)unmarkViewAsSensitive:(nonnull UIView*)view DEPRECATED_MSG_ATTRIBUTE("use `UIView.isSensitive`, `unregisterBlacklistedObject`  or `registerWhitelistedObject`.");


// MARK: - Full Sensitive Mode

/**
 Use this method to enter the **full sensitive mode**. No video is recorded, just events.
 */
+ (void)beginFullscreenSensitiveMode DEPRECATED_MSG_ATTRIBUTE("use a suitable combination of rendering and event tracking mode instead.");
/**
 Use this method to leave the **full sensitive mode**. Video is recorded again.
 */
+ (void)endFullscreenSensitiveMode DEPRECATED_MSG_ATTRIBUTE("use a suitable combination of rendering and event tracking mode instead.");
/**
 To check Smartlook full sensitive mode status. In full sensitive mode, no video is recorded, just events.

 @return fullscreen sensitive mode state
 */
+ (BOOL)isFullscreenSensitiveModeActive DEPRECATED_MSG_ATTRIBUTE("use a suitable combination of rendering and event tracking mode instead.");

// MARK: - Analytics Only Mode

/**
Use this method to enter the **analytics only mode**. No video is recorded, just analytics events are sent.
*/
+ (void)beginAnalyticsOnlyMode DEPRECATED_MSG_ATTRIBUTE("use a suitable combination of rendering and event tracking mode instead.");
/**
Use this method to leave the **analytics only mode**. Video is recorded again.
*/
+ (void)endAnalyticsOnlyMode DEPRECATED_MSG_ATTRIBUTE("use a suitable combination of rendering and event tracking mode instead.");

/**
To check Smartlook analytics only mode status. In analytics only mode, no video is recorded, just analytics events are sent.

@return analytics only mode state
*/
+ (BOOL)isAnalyticsOnlyModeActive DEPRECATED_MSG_ATTRIBUTE("use a suitable combination of rendering and event tracking mode instead.");


+ (nullable NSURL *)getDashboardSessionURL DEPRECATED_MSG_ATTRIBUTE("use `getDashboardSessionURLWithCurrentTimestamp` instead.");

@end


#endif /* Smartlook_Deprecated_h */
