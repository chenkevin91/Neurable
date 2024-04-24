// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: session.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct FocusData_Session {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var sessionStart: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _sessionStart ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_sessionStart = newValue}
  }
  /// Returns true if `sessionStart` has been explicitly set.
  var hasSessionStart: Bool {return self._sessionStart != nil}
  /// Clears the value of `sessionStart`. Subsequent reads from it will return its default value.
  mutating func clearSessionStart() {self._sessionStart = nil}

  var sessionStop: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _sessionStop ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_sessionStop = newValue}
  }
  /// Returns true if `sessionStop` has been explicitly set.
  var hasSessionStop: Bool {return self._sessionStop != nil}
  /// Clears the value of `sessionStop`. Subsequent reads from it will return its default value.
  mutating func clearSessionStop() {self._sessionStop = nil}

  var timezoneName: String = String()

  var data: [FocusData_Session.DataSample] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  struct DataSample {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    var offsetSeconds: Int32 = 0

    var focusLevel: Float = 0

    var dataQuality: Float = 0

    var unknownFields = SwiftProtobuf.UnknownStorage()

    init() {}
  }

  init() {}

  fileprivate var _sessionStart: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
  fileprivate var _sessionStop: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
}

#if swift(>=5.5) && canImport(_Concurrency)
extension FocusData_Session: @unchecked Sendable {}
extension FocusData_Session.DataSample: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "focus_data"

extension FocusData_Session: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Session"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "session_start"),
    2: .standard(proto: "session_stop"),
    3: .standard(proto: "timezone_name"),
    4: .same(proto: "data"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._sessionStart) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._sessionStop) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.timezoneName) }()
      case 4: try { try decoder.decodeRepeatedMessageField(value: &self.data) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._sessionStart {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    try { if let v = self._sessionStop {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    if !self.timezoneName.isEmpty {
      try visitor.visitSingularStringField(value: self.timezoneName, fieldNumber: 3)
    }
    if !self.data.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.data, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: FocusData_Session, rhs: FocusData_Session) -> Bool {
    if lhs._sessionStart != rhs._sessionStart {return false}
    if lhs._sessionStop != rhs._sessionStop {return false}
    if lhs.timezoneName != rhs.timezoneName {return false}
    if lhs.data != rhs.data {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension FocusData_Session.DataSample: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = FocusData_Session.protoMessageName + ".DataSample"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    5: .standard(proto: "offset_seconds"),
    6: .standard(proto: "focus_level"),
    7: .standard(proto: "data_quality"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 5: try { try decoder.decodeSingularInt32Field(value: &self.offsetSeconds) }()
      case 6: try { try decoder.decodeSingularFloatField(value: &self.focusLevel) }()
      case 7: try { try decoder.decodeSingularFloatField(value: &self.dataQuality) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.offsetSeconds != 0 {
      try visitor.visitSingularInt32Field(value: self.offsetSeconds, fieldNumber: 5)
    }
    if self.focusLevel != 0 {
      try visitor.visitSingularFloatField(value: self.focusLevel, fieldNumber: 6)
    }
    if self.dataQuality != 0 {
      try visitor.visitSingularFloatField(value: self.dataQuality, fieldNumber: 7)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: FocusData_Session.DataSample, rhs: FocusData_Session.DataSample) -> Bool {
    if lhs.offsetSeconds != rhs.offsetSeconds {return false}
    if lhs.focusLevel != rhs.focusLevel {return false}
    if lhs.dataQuality != rhs.dataQuality {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}