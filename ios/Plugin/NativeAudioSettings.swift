import Foundation
import AVFoundation

@objc public class NativeAudioSettings: NSObject {
  @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
