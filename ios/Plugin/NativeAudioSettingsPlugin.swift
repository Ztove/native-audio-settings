import Foundation
import AVFoundation
import Capacitor
import MediaPlayer

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(NativeAudioSettingsPlugin)
public class NativeAudioSettingsPlugin: CAPPlugin {
    private let implementation = NativeAudioSettings()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }

      override public func load() {
        let volumeChangeNotificationName = NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(handleVolumeChange(notification:)), name: volumeChangeNotificationName, object: nil)
    }

    private func emitNotificationVolumeChangeEvent(volume: Float, maxVolume: Float) {
        let eventData: [String: Any] = ["notificationVolume": volume, "maxNotificationVolume": maxVolume]
        notifyListeners("notificationVolumeChange", data: eventData)
    }

    @objc func getMainVolume(_ call: CAPPluginCall) {
        let audioManager = AVAudioSession.sharedInstance()
        
        let mainVolume = audioManager.outputVolume
        let maxMainVolume = getMaxVolume()

        let result: [String: Any] = ["mainVolume": mainVolume, "maxMainVolume": maxMainVolume]
        call.resolve(result)
    }

    @objc func getNotificationVolume(_ call: CAPPluginCall) {
        let audioManager = AVAudioSession.sharedInstance()
        let notificationVolume = audioManager.outputVolume
        let maxNotificationVolume = getMaxVolume()

        let result: [String: Any] = ["notificationVolume": notificationVolume, "maxNotificationVolume": maxNotificationVolume]
        call.resolve(result)
    }

    @objc func handleVolumeChange(notification: NSNotification) {
    if let userInfo = notification.userInfo,
       let changeReason = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
        if changeReason == "ExplicitVolumeChange" {
            let audioManager = AVAudioSession.sharedInstance()
            let volume = audioManager.outputVolume
            let maxVolume = getMaxVolume()
            
            let eventData: [String: Any] = ["notificationVolume": volume, "maxNotificationVolume": maxVolume]
            notifyListeners("notificationVolumeChange", data: eventData)
            self.notifyListeners("notificationVolumeChange", data: ["testData": "Test event data"])

            }
        }
    }

    private func getMaxVolume() -> Float {
        let volumeView = MPVolumeView()
        var maxVolume: Float = 1.0

        if let view = volumeView.subviews.first as? UISlider {
            maxVolume = view.maximumValue
        }

        return maxVolume
    }
}
