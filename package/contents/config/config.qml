import org.kde.plasma.configuration 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import QtQuick.Layouts 1.3

ConfigModel { 
    ConfigCategory {
        name: i18n("Event Settings")
        source: "config/EventConfig.qml"
        icon: "calendar"
    }
    
    ConfigCategory {
        name: i18n("Appearance")
        source: "config/AppearanceConfig.qml"
        icon: "preferences-desktop-theme"
    }
}
