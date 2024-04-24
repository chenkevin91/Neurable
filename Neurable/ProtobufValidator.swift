import Foundation
import SwiftProtobuf

struct ProtobufValidator {

    enum ValidationError: LocalizedError {
        case dataMissing
        case invalidDates
        case invalidTimezone
        case invalidOffsets

        var errorDescription: String? {
            switch self {
            case .dataMissing:
                "Data missing"
            case .invalidDates:
                "Invalid dates"
            case .invalidTimezone:
                "Invalid timezone"
            case .invalidOffsets:
                "Invalid offsets"
            }
        }
    }

    func validate(data: Data) -> Result<Void, Error> {
        do {
            let model = try FocusData_Session(serializedData: data)
            guard !model.data.isEmpty else {
                return .failure(ValidationError.dataMissing)
            }
            let sessionDuration = model.sessionStart.date.distance(to: model.sessionStop.date)
            guard sessionDuration > 0 else {
                return .failure(ValidationError.invalidDates)
            }
            guard let _ = TimeZone(identifier: model.timezoneName) else {
                return .failure(ValidationError.invalidTimezone)
            }
            let offsetSeconds = model.data.map { $0.offsetSeconds }
            guard let min = offsetSeconds.min(), min >= 0 else {
                return .failure(ValidationError.invalidOffsets)
            }
            guard let max = offsetSeconds.max(), max <= Int32(sessionDuration) else {
                return .failure(ValidationError.invalidOffsets)
            }

            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
