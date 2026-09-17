import org.kde.plasma.configuration 2.0 as PlasmaConfig
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15 as Controls

PlasmaConfig.ConfigGeneral {
    ColumnsView {
        width: parent.width
        Column {
            PlasmaComponents.Label {
                text: i18n("Event Name")
                width: parent.width
            }
            PlasmaComponents.TextField {
                id: eventNameField
                width: parent.width
                text: plasmoid.configuration.cfg_eventName
                onTextChanged: plasmoid.configuration.cfg_eventName = text
                placeholderText: i18n("Enter event name (e.g. SAT 2026)")
            }
            
            PlasmaComponents.Label {
                text: i18n("Event Date")
                width: parent.width
            }
            PlasmaComponents.DatePicker {
                id: datePicker
                width: parent.width
                from: new Date(2020, 0, 1)
                to: new Date(2030, 11, 31)
                calendar: plasmoid.configuration.cfg_eventDate
                onCalendarChanged: plasmoid.configuration.cfg_eventDate = calendar
            }
            
            PlasmaComponents.CheckBox {
                id: showTimeCheckbox
                text: i18n("Set specific time")
                width: parent.width
                checked: plasmoid.configuration.cfg_showTime
                onClicked: plasmoid.configuration.cfg_showTime = checked
            }
            
            // Time controls (only visible when showTime is checked)
            Row {
                visible: showTimeCheckbox.checked
                spacing: 10
                
                PlasmaComponents.Label {
                    text: i18n("Hour:")
                    width: 40
                }
                PlasmaComponents.SpinBox {
                    id: hourSpinBox
                    from: 0
                    to: 23
                    value: plasmoid.configuration.cfg_eventHour
                    width: 60
                    onValueChanged: plasmoid.configuration.cfg_eventHour = value
                }
                
                PlasmaComponents.Label {
                    text: i18n("Minute:")
                    width: 50
                }
                PlasmaComponents.SpinBox {
                    id: minuteSpinBox
                    from: 0
                    to: 59
                    value: plasmoid.configuration.cfg_eventMinute
                    width: 60
                    onValueChanged: plasmoid.configuration.cfg_eventMinute = value
                }
                
                PlasmaComponents.Label {
                    text: i18n("Second:")
                    width: 50
                }
                PlasmaComponents.SpinBox {
                    id: secondSpinBox
                    from: 0
                    to: 59
                    value: plasmoid.configuration.cfg_eventSecond
                    width: 60
                    onValueChanged: plasmoid.configuration.cfg_eventSecond = value
                }
            }
            
            PlasmaComponents.CheckBox {
                id: progressCheckbox
                text: i18n("Show progress bar")
                width: parent.width
                checked: plasmoid.configuration.cfg_showProgress
                onClicked: plasmoid.configuration.cfg_showProgress = checked
            }
        }
    }
}
