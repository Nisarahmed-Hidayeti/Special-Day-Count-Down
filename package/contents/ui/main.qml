import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    id: root

    Plasmoid.backgroundHints: PlasmaCore.Types.ShadowBackground | PlasmaCore.Types.ConfigurableBackground

    // Configuration properties with defaults
    property string eventName: plasmoid.configuration.eventName || "Special Day"
    property var eventDate: plasmoid.configuration.eventDate || new Date()
    property bool showTime: plasmoid.configuration.showTime !== undefined ? plasmoid.configuration.showTime : false
    property int eventHour: plasmoid.configuration.eventHour !== undefined ? plasmoid.configuration.eventHour : 0
    property int eventMinute: plasmoid.configuration.eventMinute !== undefined ? plasmoid.configuration.eventMinute : 0
    property int eventSecond: plasmoid.configuration.eventSecond !== undefined ? plasmoid.configuration.eventSecond : 0
    property bool showProgress: plasmoid.configuration.showProgress !== undefined ? plasmoid.configuration.showProgress : false
    property string backgroundColor: plasmoid.configuration.backgroundColor || "#00000000" // Transparent
    property real opacity: plasmoid.configuration.opacity !== undefined ? plasmoid.configuration.opacity : 1.0
    property bool showBorder: plasmoid.configuration.showBorder !== undefined ? plasmoid.configuration.showBorder : false
    property string borderColor: plasmoid.configuration.borderColor || "#FFFFFF"
    property int borderWidth: plasmoid.configuration.borderWidth !== undefined ? plasmoid.configuration.borderWidth : 1
    property string fontColor: plasmoid.configuration.fontColor || "#FFFFFF"

    // Internal state
    property int remainingDays: 0
    property int remainingHours: 0
    property int remainingMinutes: 0
    property int remainingSeconds: 0
    property bool isCompleted: false

    // Target date/time for countdown
    property var targetDate: new Date(eventDate.getFullYear(), eventDate.getMonth(), eventDate.getDate(), eventHour, eventMinute, eventSecond)

    // Timer for updating countdown
    Timer {
        id: countdownTimer
        interval: 1000 // Update every second for precision
        running: true
        repeat: true
        onTriggered: updateCountdown()
    }

    // Initialize on load
    Component.onCompleted: {
        updateCountdown()
    }

    Plasmoid.fullRepresentation: Item {
        anchors.fill: parent
        width: parent.width
        height: parent.height

        Rectangle {
            anchors.fill: parent
            color: backgroundColor
            opacity: opacity
            border.width: showBorder ? borderWidth : 0
            border.color: borderColor

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Math.max(10, parent.width * 0.05) // Responsive margin
                spacing: Math.max(5, parent.width * 0.01) // Responsive spacing

                // Event name
                Text {
                    id: eventNameText
                    text: eventName
                    Layout.alignment: Qt.AlignHCenter
                    font.family: "Poppins, Arial, sans-serif"
                    font.pointSize: Math.max(12, parent.width * 0.08)
                    color: isCompleted ? "#FF0000" : fontColor // Red when completed
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    maximumLineCount: 2
                }

                // Spacer
                Item { Layout.fillHeight: true }

                // Days countdown
                Text {
                    id: daysText
                    text: remainingDays.toString()
                    Layout.alignment: Qt.AlignHCenter
                    font.family: "Poppins, Arial, sans-serif"
                    font.pointSize: Math.max(20, parent.width * 0.15)
                    font.weight: Font.Bold
                    color: isCompleted ? "#FF0000" : fontColor
                    visible: !isCompleted
                }

                // Time countdown (only shown if time is specified or if completed to show 00:00:00)
                Row {
                    id: timeRow
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 5
                    visible: showTime || isCompleted

                    Text {
                        text: remainingHours.toString().padStart(2, '0')
                        font.family: "Poppins, Arial, sans-serif"
                        font.pointSize: Math.max(16, parent.width * 0.12)
                        font.weight: Font.Bold
                        color: isCompleted ? "#FF0000" : fontColor
                    }
                    Text {
                        text: ":"
                        font.family: "Poppins, Arial, sans-serif"
                        font.pointSize: Math.max(16, parent.width * 0.12)
                        color: isCompleted ? "#FF0000" : fontColor
                    }
                    Text {
                        text: remainingMinutes.toString().padStart(2, '0')
                        font.family: "Poppins, Arial, sans-serif"
                        font.pointSize: Math.max(16, parent.width * 0.12)
                        font.weight: Font.Bold
                        color: isCompleted ? "#FF0000" : fontColor
                    }
                    Text {
                        text: ":"
                        font.family: "Poppins, Arial, sans-serif"
                        font.pointSize: Math.max(16, parent.width * 0.12)
                        color: isCompleted ? "#FF0000" : fontColor
                    }
                    Text {
                        text: remainingSeconds.toString().padStart(2, '0')
                        font.family: "Poppins, Arial, sans-serif"
                        font.pointSize: Math.max(16, parent.width * 0.12)
                        font.weight: Font.Bold
                        color: isCompleted ? "#FF0000" : fontColor
                    }
                }

                // Progress bar
                Rectangle {
                    id: progressBarBackground
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    height: Math.max(4, parent.width * 0.02)
                    color: "#FFFFFF33" // Semi-transparent white
                    radius: 2
                    visible: showProgress && !isCompleted

                    Rectangle {
                        id: progressBarFill
                        anchors.left: parent.left
                        height: parent.height
                        width: parent.width * progress
                        color: isCompleted ? "#FF0000" : "#00FF00" // Green when not completed, red when completed
                        radius: 2
                    }
                }

                // Arrival message (shown when completed)
                Text {
                    id: arrivalText
                    text: eventName + " " + i18n("HAS ARRIVED")
                    Layout.alignment: Qt.AlignHCenter
                    font.family: "Poppins, Arial, sans-serif"
                    font.pointSize: Math.max(12, parent.width * 0.08)
                    color: "#FF0000"
                    visible: isCompleted
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    maximumLineCount: 2
                }

                // Spacer
                Item { Layout.fillHeight: true }
            }
        }
    }

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    // Function to update the countdown
    function updateCountdown() {
        var now = new Date()
        var target = targetDate

        // Calculate difference
        var diffMs = target - now

        // Check if completed
        isCompleted = diffMs <= 0

        if (isCompleted) {
            remainingDays = 0
            remainingHours = 0
            remainingMinutes = 0
            remainingSeconds = 0
        } else {
            // Calculate time components
            var diffSec = Math.floor(diffMs / 1000)

            remainingDays = Math.floor(diffSec / (24 * 3600))
            diffSec %= (24 * 3600)

            remainingHours = Math.floor(diffSec / 3600)
            diffSec %= 3600

            remainingMinutes = Math.floor(diffSec / 60)
            remainingSeconds = diffSec % 60
        }

        // Update progress if enabled
        if (showProgress && !isCompleted) {
            var startDate = plasmoid.configuration.startDate || new Date() // Default to now if not set
            var totalTime = targetDate - startDate
            var elapsedTime = targetDate - now
            progress = Math.max(0, Math.min(1, 1 - (elapsedTime / totalTime)))
        }
    }

    // Property for progress bar (0 to 1)
    property real progress: 0
}
