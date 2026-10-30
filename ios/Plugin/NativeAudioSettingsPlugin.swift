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
    private var lastNotifiedVolume: Float?

    override public func load() {
        // Private notifications, so we don't have to activate the audio session (which would stop other apps' audio).
        // iOS 15+ posts SystemVolumeDidChange, older versions AVSystemController_SystemVolumeDidChangeNotification.
        for name in ["SystemVolumeDidChange", "AVSystemController_SystemVolumeDidChangeNotification"] {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(volumeDidChange(_:)),
                name: NSNotification.Name(rawValue: name),
                object: nil
            )
        }
    }

    @objc private func volumeDidChange(_ notification: Notification) {
        // outputVolume can be stale while the audio session is inactive, so prefer the value from the notification
        let userInfoVolume = (notification.userInfo?["Volume"] ?? notification.userInfo?["AVSystemController_AudioVolumeNotificationParameter"]) as? Float
        let notificationVolume = userInfoVolume ?? AVAudioSession.sharedInstance().outputVolume
        // Both notifications can fire for the same change
        if notificationVolume == lastNotifiedVolume {
            return
        }
        lastNotifiedVolume = notificationVolume
        let maxNotificationVolume = getMaxVolume()
        let eventData: [String: Any] = ["notificationVolume": notificationVolume, "maxNotificationVolume": maxNotificationVolume]
        self.notifyListeners("notificationVolumeChange", data: eventData)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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

    private func getMaxVolume() -> Float {
        var maxVolume: Float = 1.0

        if Thread.isMainThread {
            let volumeView = MPVolumeView()
            if let view = volumeView.subviews.first as? UISlider {
                maxVolume = view.maximumValue
            }
        } else {
            DispatchQueue.main.sync {
                let volumeView = MPVolumeView()
                if let view = volumeView.subviews.first as? UISlider {
                    maxVolume = view.maximumValue
                }
            }
        }

        return maxVolume
    }
}
