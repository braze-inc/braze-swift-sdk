@import Foundation;
#import "BrazePreprocessor.h"

/*!
 * Enum representing the accepted SDK Metatadata.
 * See addSdkMetadata for more details.
 */
typedef NSString *ABKSdkMetadata NS_TYPED_EXTENSIBLE_ENUM BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata'");
extern ABKSdkMetadata const ABKSdkMetadataAdjust BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.adjust'");
extern ABKSdkMetadata const ABKSdkMetadataAirBridge BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.airbridge'");
extern ABKSdkMetadata const ABKSdkMetadataAppsFlyer BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.appsflyer'");
extern ABKSdkMetadata const ABKSdkMetadataBluedot BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.bluedot'");
extern ABKSdkMetadata const ABKSdkMetadataBranch BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.branch'");
extern ABKSdkMetadata const ABKSdkMetadataCordova BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.cordova'");
extern ABKSdkMetadata const ABKSdkMetadataCarthage BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.carthage'");
extern ABKSdkMetadata const ABKSdkMetadataCocoaPods BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.cocoapods'");
extern ABKSdkMetadata const ABKSdkMetadataCordovaPM BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.cordovapm'");
extern ABKSdkMetadata const ABKSdkMetadataExpo BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.expo'");
extern ABKSdkMetadata const ABKSdkMetadataFoursquare BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.foursquare'");
extern ABKSdkMetadata const ABKSdkMetadataFlutter BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.flutter'");
extern ABKSdkMetadata const ABKSdkMetadataGoogleTagManager BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.googletagmanager'");
extern ABKSdkMetadata const ABKSdkMetadataGimbal BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.gimbal'");
extern ABKSdkMetadata const ABKSdkMetadataGradle BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.gradle'");
extern ABKSdkMetadata const ABKSdkMetadataIonic BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.ionic'");
extern ABKSdkMetadata const ABKSdkMetadataKochava BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.kochava'");
extern ABKSdkMetadata const ABKSdkMetadataManual BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.manual'");
extern ABKSdkMetadata const ABKSdkMetadataMParticle BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.mparticle'");
extern ABKSdkMetadata const ABKSdkMetadataNativeScript BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.nativescript'");
extern ABKSdkMetadata const ABKSdkMetadataNPM BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.npm'");
extern ABKSdkMetadata const ABKSdkMetadataNuGet BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.nuget'");
extern ABKSdkMetadata const ABKSdkMetadataPub BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.pub'");
extern ABKSdkMetadata const ABKSdkMetadataRadar BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.radar'");
extern ABKSdkMetadata const ABKSdkMetadataReactNative BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.reactnative'");
extern ABKSdkMetadata const ABKSdkMetadataSegment BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.segment'");
extern ABKSdkMetadata const ABKSdkMetadataSingular BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.singular'");
extern ABKSdkMetadata const ABKSdkMetadataSwiftPM BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.swiftpm'");
extern ABKSdkMetadata const ABKSdkMetadataTealium BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.tealium'");
extern ABKSdkMetadata const ABKSdkMetadataUnreal BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.unreal'");
extern ABKSdkMetadata const ABKSdkMetadataUnityPM BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.unitypm'");
extern ABKSdkMetadata const ABKSdkMetadataUnity BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.unity'");
extern ABKSdkMetadata const ABKSdkMetadataVizbee BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.vizbee'");
extern ABKSdkMetadata const ABKSdkMetadataXamarin BRZ_DEPRECATED("renamed to 'Braze.Configuration.Api.SDKMetadata.xamarin'");
