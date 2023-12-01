#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(NativeAudioSettingsPlugin, "NativeAudioSettings",
           CAP_PLUGIN_METHOD(echo, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getMainVolume, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getNotificationVolume, CAPPluginReturnPromise);
)
