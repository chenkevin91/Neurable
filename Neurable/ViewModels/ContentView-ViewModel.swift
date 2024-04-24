//
//  ContentView-ViewModel.swift
//  Neurable
//
//  Created by Kevin Chen on 4/22/24.
//

import Foundation
import SwiftProtobuf

extension ContentView {
    typealias ChartData = (focus: Float, timestamp: Date)

    struct FocusLine: Identifiable {
        let id: String
        var data: [ChartData]

        mutating func add(newData: ChartData) {
            data.append(newData)
        }
    }

    enum ViewState {
        case receivingData
        case welcome
        case ended
    }

    class ViewModel: ObservableObject {
        private var timer: Timer?
        private var session: FocusData_Session? {
            didSet {
                if let startDate = session?.sessionStart.date,
                   let latestDataOffset = session?.data.last?.offsetSeconds {
                    trackerDate = startDate.addingTimeInterval(TimeInterval(latestDataOffset + 2))
                }
                updateFocusLines()
            }
        }
        
        @Published var chartXScaleRange: ClosedRange<Date> = Date()...Date().addingTimeInterval(TimeInterval(45))
        @Published var trackerDate: Date = Date()
        @Published var state: ViewState = .welcome
        @Published var lines = [FocusLine]()
        @Published var showingAlert = false
        var failureReason: String? = nil

        func startSession() {
            var newSession = FocusData_Session()
            newSession.sessionStart = Google_Protobuf_Timestamp(date: Date())
            newSession.timezoneName = TimeZone.current.identifier
            session = newSession
            addTimer()
            state = .receivingData
        }

        func endSession() {
            removeTimer()
            session?.sessionStop = Google_Protobuf_Timestamp(date: Date())
            state = .ended
        }

        func clearSession() {
            endSession()
            session = nil
            state = .welcome
            chartXScaleRange = Date()...Date().addingTimeInterval(TimeInterval(45))
            trackerDate = Date()
            failureReason = nil
        }

        func submitSession() {
            guard 
                let session = session,
                let serialized = try? session.serializedData()
            else { return }

            switch ProtobufValidator().validate(data: serialized) {
            case .success:
                showingAlert = true
            case .failure(let error):
                showingAlert = true
                failureReason = error.localizedDescription
            }
        }

        private func updateFocusLines() {
            lines.removeAll()
            guard let session = session else { return }
            let sessionStartDate = session.sessionStart.date
            let filtered = Array(session.data.suffix(30)).filter { $0.dataQuality >= 30.0 }
            let set = Set(filtered)

            for data in filtered {
                if !set.contains(where: { $0.offsetSeconds ==  data.offsetSeconds - 1 }) {
                    let dataDate = sessionStartDate.addingTimeInterval(TimeInterval(data.offsetSeconds))
                    var newLine = FocusLine(id: dataDate.description, data: [])
                    var length = Int32(0)
                    while let nextData = set.first(where: { $0.offsetSeconds ==  data.offsetSeconds + length }) {
                        let nextDataDate = sessionStartDate.addingTimeInterval(TimeInterval(nextData.offsetSeconds))
                        let nextChartData = (focus: nextData.focusLevel, timestamp: nextDataDate)
                        if lines.isEmpty && newLine.data.isEmpty {
                            chartXScaleRange = nextChartData.timestamp...nextChartData.timestamp.addingTimeInterval(TimeInterval(45))
                        }
                        newLine.add(newData: nextChartData)
                        length += 1
                    }
                    lines.append(newLine)
                }
            }
        }
    }
}

extension ContentView.ViewModel {
    private func addTimer() {
        removeTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            let random = Int.random(in: 0...100)
            if random > 2 {
                let offset = Date().timeIntervalSince(self?.session?.sessionStart.date ?? Date())
                var newFocusData = FocusData_Session.DataSample()
                newFocusData.offsetSeconds = Int32(offset.rounded())
                newFocusData.dataQuality = Float.random(in: 0.0...100.0)
                newFocusData.focusLevel = Float.random(in: 0.0...100.0)
                self?.session?.data.append(newFocusData)
            } else {
                print("whoops")
            }
        }
    }

    private func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
}
