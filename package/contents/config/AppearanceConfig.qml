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
                text: i18n("Background Color")
                width: parent.width
            }
            PlasmaComponents.ColorField {
                id: bgColorField
                width: parent.width
                color: plasmoid.configuration.cfg_backgroundColor
                onColorChanged: plasmoid.configuration.cfg_backgroundColor = color
            }
            
            PlasmaComponents.Label {
                text: i18n("Opacity")
                width: parent.width
            }
            PlasmaComponents.Slider {
                id: opacitySlider
                width: parent.width
                from: 0.0
                to: 1.0
                value: plasmoid.configuration.cfg_opacity
                stepSize: 0.05
                onValueChanged: plasmoid.configuration.cfg_opacity = value
                Labels {
                    text: Math.round(value * 100) + "%"
                }
            }
            
            PlasmaComponents.CheckBox {
                id: borderCheckbox
                text: i18n("Show Border")
                width: parent.width
                checked: plasmoid.configuration.cfg_showBorder
                onClicked: plasmoid.configuration.cfg_showBorder = checked
            }
            
            Row {
                visible: borderCheckbox.checked
                spacing: 10
                
                PlasmaComponents.Label {
                    text: i18n("Border Color:")
                    width: 80
                }
                PlasmaComponents.ColorField {
                    id: borderColorField
                    width: 100
                    color: plasmoid.configuration.cfg_borderColor
                    onColorChanged: plasmoid.configuration.cfg_borderColor = color
                }
                
                PlasmaComponents.Label {
                    text: i18n("Border Width:")
                    width: 80
                }
                PlasmaComponents.SpinBox {
                    id: borderWidthSpinBox
                    from: 0
                    to: 10
                    value: plasmoid.configuration.cfg_borderWidth
                    width: 60
                    onValueChanged: plasmoid.configuration.cfg_borderWidth = value
                }
            }
            
            PlasmaComponents.Label {
                text: i18n("Font Color")
                width: parent.width
            }
            PlasmaComponents.ColorField {
                id: fontColorField
                width: parent.width
                color: plasmoid.configuration.cfg_fontColor
                onColorChanged: plasmoid.configuration.cfg_fontColor = color
            }
            
            PlasmaComponents.Label {
                text: i18n("Start Date (for progress)")
                width: parent.width
            }
            PlasmaComponents.DatePicker {
                id: startDatePicker
                width: parent.width
                from: new Date(2020, 0, 1)
                to: new Date(2030, 11, 31)
                calendar: plasmoid.configuration.cfg_startDate
                onCalendarChanged: plasmoid.configuration.cfg_startDate = calendar
            }
        }
    }
}
