// Special Day Countdown calculation logic

// Calculate progress (0 to 1)
// Note: This requires knowing the start date, which we'll handle in main.qml
function calculateProgress(startDate, targetDate, currentDate) {
    if (!startDate || !targetDate || !currentDate) {
        return 0;
    }

    var totalTime = targetDate - startDate;
    var elapsedTime = targetDate - currentDate;

    if (totalTime <= 0) {
        return 1; // Completed or invalid
    }

    var progress = 1 - (elapsedTime / totalTime);
    return Math.max(0, Math.min(1, progress)); // Clamp between 0 and 1
}

// Main function to be called from QML
function getProgress(startDate, eventDate, showTime, eventHour, eventMinute, eventSecond) {
    if (!startDate) return 0;

    var target = new Date(eventDate.getFullYear(), eventDate.getMonth(), eventDate.getDate(),
                         eventHour, eventMinute, eventSecond);
    var now = new Date();
    return calculateProgress(startDate, target, now);
}
