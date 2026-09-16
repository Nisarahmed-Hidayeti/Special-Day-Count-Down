import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

import "calc.js" as Calc

Item {
    id: root

    Plasmoid.backgroundHints: PlasmaCore.Types.ShadowBackground | PlasmaCore.Types.ConfigurableBackground

    // Configuration property bindings
    property string eventName: plasmoid.configuration.cfg_eventName || "Special Day"
    property var eventDate: plasmoid.configuration.cfg_eventDate || new Date()
    property bool showTime: plasmoid.configuration.cfg_showTime !== undefined ? plasmoid.configuration.cfg_showTime : false
    property int eventHour: plasmoid.configuration.cfg_eventHour !== undefined ? plasmoid.configuration.cfg_eventHour : 0
    property int eventMinute: plasmoid.configuration.cfg_eventMinute !== undefined ? plasmoid.configuration.cfg_eventMinute : 0
    property int eventSecond: plasmoid.configuration.cfg_eventSecond !== undefined ? plasmoid.configuration.cfg_eventSecond : 0
    property bool showProgress: plasmoid.configuration.cfg_showProgress !== undefined ? plasmoid.configuration.cfg_showProgress : false
    property string backgroundColor: plasmoid.configuration.cfg_backgroundColor || "#00000000" // Transparent
    property real opacity: plasmoid.configuration.cfg_opacity !== undefined ? plasmoid.configuration.cfg_opacity : 1.0
    property bool showBorder: plasmoid.configuration.cfg_showBorder !== undefined ? plasmoid.configuration.cfg_showBorder : false
    property string borderColor: plasmoid.configuration.cfg_borderColor || "#FFFFFF"
    property int borderWidth: plasmoid.configuration.cfg_borderWidth !== undefined ? plasmoid.configuration.cfg_borderWidth : 1
    property string fontColor: plasmoid.configuration.cfg_fontColor || "#FFFFFF"
    property var startDate: plasmoid.configuration.cfg_startDate || new Date() // For progress calculation

    // Internal state for display
    property int remainingDays: 0
    property int remainingHours: 0
    property int remainingMinutes: 0
    property int remainingSeconds: 0
    property bool isCompleted: false
    property real progress: 0

    // Timer for updating countdown
    Timer {
        id: countdownTimer
        interval: 1000 // Update every second
        running: true
        repeat: true
        onTriggered: updateCountdown()
    }

    // Initialize on load
    Component.onCompleted: {
        // Set default date if not configured (e.g., 30 days from now)
        if (!plasmoid.configuration.cfg_eventDate) {
            var defaultDate = new Date();
            defaultDate.setDate(defaultDate.getDate() + 30);
            plasmoid.configuration.cfg_eventDate = defaultDate;
        }
        updateCountdown();
    }

    // Update the countdown values
    function updateCountdown() {
        remainingDays = Calc.getDays(eventName, eventDate, showTime, eventHour, eventMinute, eventSecond);
        remainingHours = Calc.getHours(eventName, eventDate, showTime, eventHour, eventMinute, eventSecond);
        remainingMinutes = Calc.getMinutes(eventName, eventDate, showTime, eventHour, eventMinute, eventSecond);
        remainingSeconds = Calc.getSeconds(eventName, eventDate, showTime, eventHour, eventMinute, eventSecond);
        isCompleted = Calc.isCompleted(eventName, eventDate, showTime, eventHour, eventMinute, eventSecond);
        progress = Calc.getProgress(startDate, eventDate, showTime, eventHour, eventMinute, eventSecond);
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
                    color: isCompleted ? "#FF0000" : fontColor
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
                        color: "#00FF00" // Green when not completed
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
}