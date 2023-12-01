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
    private var volumeValueObservation: NSKeyValueObservation?

    override public func load() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setActive(true)
            
            volumeValueObservation = audioSession.observe(\.outputVolume) { av, _ in
                let notificationVolume = av.outputVolume
                let maxNotificationVolume = self.getMaxVolume()

                let eventData: [String: Any] = ["notificationVolume": notificationVolume, "maxNotificationVolume": maxNotificationVolume]
                self.notifyListeners("notificationVolumeChange", data: eventData)
            }
        } catch let error {
            print(">>> ERROR: Unable to set audio session active: \(error)")
        }
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
        let volumeView = MPVolumeView()
        var maxVolume: Float = 1.0

        if let view = volumeView.subviews.first as? UISlider {
            maxVolume = view.maximumValue
        }

        return maxVolume
    }
}
