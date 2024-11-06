/// Wrapper class to contain the corresponding `BrazeKit` struct.
///
/// Various BrazeUI types are represented as structs and imported from BrazeKit.
/// This wrapper acts as a workaround to prevent Objective-C metaclass errors.
class StructWrapper<WrappedType> {
  var wrappedValue: WrappedType

  /// Initializes the wrapper with the wrapped struct.
  ///
  /// - Parameter wrappedValue: The wrapped struct type.
  init(wrappedValue: WrappedType) {
    self.wrappedValue = wrappedValue
  }
}
