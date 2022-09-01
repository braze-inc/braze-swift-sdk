import BrazeKit
import Foundation

// MARK: - Braze

extension Braze.InAppMessage.Color {

  var hexString: String {
    // Color is ARGB, convert to RGBA + display as hex value
    String(format: "#%08X", rawValue << 8 | UInt32(a * 255.0))
  }

}

// MARK: - Foundation

extension Encodable {

  func prettyPrint() -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    if #available(iOS 11.0, tvOS 11.0, *) {
      encoder.outputFormatting.insert(.sortedKeys)
    }
    if #available(iOS 13.0, tvOS 13.0, *) {
      encoder.outputFormatting.insert(.withoutEscapingSlashes)
    }

    guard let data = try? encoder.encode(self),
      let prettyPrinted = String(data: data, encoding: .utf8)
    else {
      return "\(self)"
    }

    return prettyPrinted
  }

}

extension Dictionary where Key == String, Value == Any {

  func prettyPrint() -> String {
    var options: JSONSerialization.WritingOptions = .prettyPrinted
    if #available(iOS 11.0, tvOS 11.0, *) {
      options.insert(.sortedKeys)
    }
    if #available(iOS 13.0, tvOS 13.0, *) {
      options.insert(.withoutEscapingSlashes)
    }

    guard let data = try? JSONSerialization.data(withJSONObject: self, options: options),
      let prettyPrinted = String(data: data, encoding: .utf8)
    else {
      return "\(self)"
    }

    return prettyPrinted
  }

}
