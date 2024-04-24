//
//  ContentView.swift
//  Neurable
//
//  Created by Kevin Chen on 4/22/24.
//

import SwiftUI
import Charts

struct ContentView: View {
    @ObservedObject private var viewModel = ViewModel()

    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .welcome:
                VStack {
                    Text("Work Smarter")
                        .font(.headline)
                    Text("Not Longer")
                        .font(.headline)
                }
                .padding()
                .navigationTitle("Neurable")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button("Start") {
                        viewModel.startSession()
                    }
                }
            case .receivingData, .ended:
                Chart(viewModel.lines, id: \.id) { line in
                    ForEach(line.data, id: \.timestamp) {
                        LineMark(
                            x: .value("Timestamp", $0.timestamp, unit: .second),
                            y: .value("Focus", $0.focus),
                            series: .value("Line", line.id)
                        )
                    }
                    .symbol {
                        Circle()
                            .fill(.yellow)
                            .frame(width: 10)
                            .shadow(radius: 2)
                    }
                    .interpolationMethod(.catmullRom)
                }
                .chartYScale(domain: 0...100)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXScale(domain: viewModel.chartXScaleRange)
                .chartOverlay { proxy in
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(uiColor: UIColor.systemBlue))
                        .frame(width: 3, height: proxy.plotSize.height)
                        .position(x: proxy.position(forX: viewModel.trackerDate) ?? CGFloat(250),
                                  y: proxy.position(forY: 50.0) ?? CGFloat(100))
                    Circle()
                        .fill(.white)
                        .frame(width: 25, height: 25)
                        .position(x: proxy.position(forX: viewModel.trackerDate) ?? CGFloat(250),
                                  y: proxy.position(forY: 100.0) ?? CGFloat(100))
                        .shadow(color: Color(uiColor: UIColor.systemBlue), radius: 25)
                    Circle()
                        .fill(Color(uiColor: UIColor.systemBlue))
                        .frame(width: 19, height: 19)
                        .position(x: proxy.position(forX: viewModel.trackerDate) ?? CGFloat(250),
                                  y: proxy.position(forY: 100.0) ?? CGFloat(100))
                }
                .padding()
                .navigationTitle("Neurable")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    switch viewModel.state {
                    case .receivingData:
                        Button("End") {
                            viewModel.endSession()
                        }
                    case .welcome:
                        Button("Start") {
                            viewModel.startSession()
                        }
                    case .ended:
                        Button("Reset") {
                            viewModel.clearSession()
                        }
                        Button("Submit") {
                            viewModel.submitSession()
                        }
                    }
                }
                .alert(isPresented: $viewModel.showingAlert) {
                    if let error = viewModel.failureReason {
                        Alert(title: Text("Session Submission Failed"),
                              message: Text("Submission was unsuccessful due to: \(error)"),
                              dismissButton: .default(Text("OK")))
                    } else {
                        Alert(title: Text("Session Submitted"),
                              message: Text("Submission was successful"),
                              dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
