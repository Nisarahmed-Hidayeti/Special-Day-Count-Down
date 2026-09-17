import QtQuick 2.0
import "calc.js" as Calc

Item {
    Component.onCompleted: {
        var eventName = "Test Event";
        var eventDate = new Date(2026, 10, 1, 12, 0, 0); // Nov 1, 2026 12:00:00
        var showTime = false;
        var hour = 0, minute = 0, second = 0;

        console.log("Days until event:", Calc.getDays(eventName, eventDate, showTime, hour, minute, second));
        console.log("Hours:", Calc.getHours(eventName, eventDate, showTime, hour, minute, second));
        console.log("Minutes:", Calc.getMinutes(eventName, eventDate, showTime, hour, minute, second));
        console.log("Seconds:", Calc.getSeconds(eventName, eventDate, showTime, hour, minute, second));
        console.log("Is completed:", Calc.isCompleted(eventName, eventDate, showTime, hour, minute, second));

        // Test with a past date
        var pastDate = new Date(2020, 0, 1);
        console.log("Past date days:", Calc.getDays(eventName, pastDate, showTime, hour, minute, second));
        console.log("Past date completed:", Calc.isCompleted(eventName, pastDate, showTime, hour, minute, second));

        Qt.quit();
    }
}
