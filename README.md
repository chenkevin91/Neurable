
The app opens to a simple screen with a right navigation bar button `Start`. 
Tapping this button will display the graph, create a `FocusData_Session`, and start generating mocked `FocusData_Session.DataSample` every second.
As the mocked data is being generated, the line graph is updated and shows the user their focus levels. 
Gaps in between the lines represents data that was ignored due to poor data quality or potentially missing data due to "connection issues" (this is currently set to 2% chance of missing data).
In the chart screen, the right navigation bar button is now the `End` button.
Tapping this button will end the current session and stop the mocked data.
Once the session is stopped, 2 new navigation bar buttons appear, `Reset` and `Submit`.
`Reset` will bring the user back to the first welcome screen.
`Submit` will feed the just ended session to `ProtobufValidator().validate` which will prompt an alert informing the user if the session was valid or not.

The majority of the code is contained in 2 files, `ContentView.swift` and `ContentView-ViewModel.swift`.
Following the model-view-view model architecture pattern, all of the ui code lives in `ContentView.swift` while all of the business logic is handled in `ContentView-ViewModel.swift`. 
When the `Start` button is tapped, `ContentView-ViewModel.swift` creates a new `FocusData_Session` and sets its `sessionStart` and `timezoneName`. The view model also starts a timer.
The timer ticks every second and generates the mocked `FocusData_Session.DataSample` which is added to the session's `data` array.
Once the user taps `End`, `FocusData_Session`'s `sessionStop` is set and the timer is killed, stopping the mocked data.
In order to draw the lines, `updateFocusLines` is called every time the session is updated.
`updateFocusLines` first filters `FocusData_Session.data` for its last 30 `DataSample` as well as filters out any `DataSample` that is considered low quality (dataQuality < 30.0).
Returning up to the last 30 `DataSample` allows us to satisfy the AC of charting the user's focus level in the last 30 seconds.
The function then goes through this filtered array and creates subarrays of `DataSample` that appear consecutively in the filtered array.
This is needed in order for `ContentView.swift` to be able to draw multiple lines and show the gaps representing missing data. 
So for instance, if the filtered data contained the following offsets: [1,2,3,5,7,8,10,11,13], the function would return [[1,2,3], [5], [7,8], [10,11], [13]].
Each subarray represents its own line and is drawn separately from each other by `ContentView.swift`
The `lines` property is what the view model feeds the view in order to draw the line chart. 
`lines` is an array of `FocusLine`, a struct that contains a String `id` and [ChartData] `data` properties.
`ChartData` is an aliased tuple `(focus: Float, timestamp: Date)`
`focus` is `DataSample.focusLevel` 
`timestamp` is generated from `DataSample.offsetSeconds` and `FocusData_Session.sessionStart.date`