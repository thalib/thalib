PlaybackThread
bt_a2dp_hw
str_params
AudioHAL
bt_btm_pm
PlaybackTestFragment

Here's an example of a filter expression that suppresses all log messages except those with the tag "ActivityManager", at priority "Info" or above, and all log messages with tag "MyApp", with priority "Debug" or above:
adb logcat ActivityManager:I MyApp:D *:S

The final element in the above expression, *:S, sets the priority level for all tags to "silent", thus ensuring only log messages with "View" and "MyApp" are displayed.
V — Verbose (lowest priority)
D — Debug
I — Info
W — Warning
E — Error
F — Fatal
S — Silent (highest priority, on which nothing is ever printed)

```
logcat InputEventConsistencyVerifier:S
```
bt_a2dp_hw
str_params
AudioHAL
bt_btm_pm
PlaybackTestFragment

logcat InputEventConsistencyVerifier:S

https://stackoverflow.com/questions/7537419/how-to-filter-android-logcat-by-application
https://developer.android.com/studio/command-line/logcat.html
