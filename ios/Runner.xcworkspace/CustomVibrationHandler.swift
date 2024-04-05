import UIKit
import Flutter

class Vibration: NSObject, FlutterPlatformView {
  private let channel: FlutterMethodChannel

  init(frame: CGRect, viewIdentifier id: Int64, arguments arguments: Any?, channel: FlutterMethodChannel) {
    self.channel = channel
    super.init(frame: frame)
  }

  func dispose() {}

  func view() -> UIView {
    return UIView()
  }

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "vibration", binaryMessenger: registrar.messenger)
    registrar.register{ (call, result) in
      if call.method == "vibrate" {
        guard let args = call.arguments as? Dictionary<String, Double>,
              let intensity = args["intensity"] else {
                result(FlutterError(code: "invalidArguments", message: "Missing intensity argument"))
                return
              }
        vibrate(intensity: intensity)
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func vibrate(intensity: Double) {
    guard intensity >= 0.0 && intensity <= 1.0 else { return }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    let options = [kAudioServicesPlaySystemSoundOption_Amplitude: intensity] as CFDictionary
    AudioServicesPlaySystemSoundWithOptions(kSystemSoundID_Vibrate, options)
  }
}
