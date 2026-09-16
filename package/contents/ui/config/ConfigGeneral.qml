import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.9 as Kirigami
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: root

    // Configuration properties
    property alias cfg_eventName: eventNameField.text
    property alias cfg_eventDate: eventDate.date
    property alias cfg_showTime: showTimeSwitch.checked
    property alias cfg_eventHour: hourSpinBox.value
    property alias cfg_eventMinute: minuteSpinBox.value
    property alias cfg_eventSecond: secondSpinBox.value
    property alias cfg_showProgress: showProgressSwitch.checked
    property alias cfg_backgroundColor: colorButton.color
    property alias cfg_opacity: opacitySlider.value
    property alias cfg_showBorder: showBorderSwitch.checked
    property alias cfg_borderColor: borderColorButton.color
    property alias cfg_borderWidth: borderWidthSpinBox.value
    property alias cfg_fontColor: fontColorButton.color

    Kirigami.FormLayout {
        // Event Name Field
        Kirigami.Label {
            Kirigami.FormData.label: i18n("Event Name:")
        }
        Kirigami.TextField {
            id: eventNameField
            placeholderText: i18n("Enter event name (e.g., SAT 2026)")
            Kirigami.FormData.placeholder: i18n("Event name")
            text: "Special Day"
        }

        // Date Selection
        Kirigami.Label {
            Kirigami.FormData.label: i18n("Event Date:")
        }
        // Using Kirigami.DatePicker if available, otherwise fallback to simple controls
        // For simplicity, we'll use separate spinboxes for date components
        RowLayout {
            spacing: 10
            Kirigami.SpinBox {
                id: yearSpinBox
                from: 2020
                to: 2100
                value: 2026
                readOnly: true
                Layout.minimumWidth: 80
            }
            Kirigami.Label { text: "-" }
            Kirigami.SpinBox {
                id: monthSpinBox
                from: 1
                to: 12
                value: 11
                readOnly: true
                Layout.minimumWidth: 50
            }
            Kirigami.Label { text: "-" }
            Kirigami.SpinBox {
                id: daySpinBox
                from: 1
                to: 31
                value: 7
                readOnly: true
                Layout.minimumWidth: 50
            }
        }

        // Optional Time
        Kirigami.Switch {
            id: showTimeSwitch
            Kirigami.FormData.label: i18n("Set specific time")
            checked: false
        }
        RowLayout {
            id: timeControls
            visible: showTimeSwitch.checked
            spacing: 10
            Kirigami.Label {
                text: i18n("Time:")
                alignment: Qt.AlignVCenter
            }
            Kirigami.SpinBox {
                id: hourSpinBox
                from: 0
                to: 23
                value: 8
                readOnly: true
                Layout.minimumWidth: 50
            }
            Kirigami.Label { text: ":" }
            Kirigami.SpinBox {
                id: minuteSpinBox
                from: 0
                to: 59
                value: 0
                readOnly: true
                Layout.minimumWidth: 50
            }
            Kirigami.Label { text: ":" }
            Kirigami.SpinBox {
                id: secondSpinBox
                from: 0
                to: 59
                value: 0
                readOnly: true
                Layout.minimumWidth: 50
            }
        }

        Kirigami.Switch {
            id: showProgressSwitch
            Kirigami.FormData.label: i18n("Show progress bar")
            checked: false
        }

        // Appearance Section
        Kirigami.Label {
            text: i18n("Appearance")
            font.weight: Font.DemiBold
            Kirigami.FormData.label: i18n("Appearance")
        }

        // Background Color
        RowLayout {
            Kirigami.Label {
                text: i18n("Background Color:")
                alignment: Qt.AlignVCenter
            }
            PlasmaComponents.ColorButton {
                id: colorButton
                color: "#00000000" // Transparent by default
                Kirigami.FormData.label: i18n("Background color")
            }
        }

        // Opacity Slider
        RowLayout {
            Kirigami.Label {
                text: i18n("Opacity:")
                alignment: Qt.AlignVCenter
            }
            Kirigami.Slider {
                id: opacitySlider
                from: 0.1
                to: 1.0
                value: 1.0
                stepSize: 0.05
                Layout.fillWidth: true
            }
            Kirigami.Label {
                text: opacitySlider.value.toFixed(2)
                width: 40
                alignment: Qt.AlignVCenter
            }
        }

        // Border Controls
        Kirigami.Switch {
            id: showBorderSwitch
            Kirigami.FormData.label: i18n("Show border")
            checked: false
        }
        RowLayout {
            id: borderControls
            visible: showBorderSwitch.checked
            spacing: 10
            Kirigami.Label {
                text: i18n("Border Color:")
                alignment: Qt.AlignVCenter
            }
            PlasmaComponents.ColorButton {
                id: borderColorButton
                color: "#FFFFFF"
                Kirigami.FormData.label: i18n("Border color")
            }
            Kirigami.Label {
                text: i18n("Width:")
                alignment: Qt.AlignVCenter
            }
            Kirigami.SpinBox {
                id: borderWidthSpinBox
                from: 1
                to: 10
                value: 2
                readOnly: true
                Layout.minimumWidth: 40
            }
        }

        // Font Color
        RowLayout {
            Kirigami.Label {
                text: i18n("Font Color:")
                alignment: Qt.AlignVCenter
            }
            PlasmaComponents.ColorButton {
                id: fontColorButton
                color: "#FFFFFF"
                Kirigami.FormData.label: i18n("Font color")
            }
        }

        // Connect time visibility to the switch
        Connections {
            target: showTimeSwitch
            onCheckedChanged: timeControls.visible = checked
        }

        // Connect border visibility to the switch
        Connections {
            target: showBorderSwitch
            onCheckedChanged: borderControls.visible = checked
        }
    }
}
