// Special Day Countdown calculation logic

// Calculate the time difference between two dates
function calculateTimeDifference(targetDate) {
    var now = new Date();
    var diffMs = targetDate - now;

    // If target has passed, return zero values
    if (diffMs <= 0) {
        return {
            days: 0,
            hours: 0,
            minutes: 0,
            seconds: 0,
            completed: true
        };
    }

    // Calculate time components
    var diffSec = Math.floor(diffMs / 1000);

    var days = Math.floor(diffSec / (24 * 3600));
    diffSec %= (24 * 3600);

    var hours = Math.floor(diffSec / 3600);
    diffSec %= 3600;

    var minutes = Math.floor(diffSec / 60);
    var seconds = diffSec % 60;

    return {
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        completed: false
    };
}

// Calculate progress (0 to 1)
// Note: This requires knowing the start date
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

// Exported functions for use in QML
function getDays(eventName, eventDate, showTime, eventHour, eventMinute, eventSecond) {
    // Create target date from the provided components
    var target = new Date(eventDate.getFullYear(), eventDate.getMonth(), eventDate.getDate(),
                         eventHour, eventMinute, eventSecond);
    var timeInfo = calculateTimeDifference(target);
    return timeInfo.days;
}

function getHours(eventName, eventDate, showTime, eventHour, eventMinute, eventSecond) {
    // Create target date from the provided components
    var target = new Date(eventDate.getFullYear(), eventDate.getMonth(), eventDate.getDate(),
                         eventHour, eventMinute, eventSecond);
    var timeInfo = calculateTimeDifference(target);
    return timeInfo.hours;
}

function getMinutes(eventName, eventDate, showTime, eventHour, eventMinute, eventSecond) {
    // Create target date from the provided components
    var target = new Date(eventDate.getFullYear(), eventDate.getMonth(), eventDate.getDate(),
                         eventHour, eventMinute, eventSecond);
    var timeInfo = calculateTimeDifference(target);
    return timeInfo.minutes;
}

function getSeconds(eventName, eventDate, showTime, eventHour, eventMinute, eventSecond) {
    // Create target date from the provided components
    var target = new Date(eventDate.getFullYear(), eventDate.getMonth(), eventDate.getDate(),
                         eventHour, eventMinute, eventSecond);
    var timeInfo = calculateTimeDifference(target);
    return timeInfo.seconds;
}

function isCompleted(eventName, eventDate, showTime, eventHour, eventMinute, eventSecond) {
    // Create target date from the provided components
    var target = new Date(eventDate.getFullYear(), eventDate.getMonth(), eventDate.getDate(),
                         eventHour, eventMinute, eventSecond);
    var timeInfo = calculateTimeDifference(target);
    return timeInfo.completed;
}

function getProgress(startDate, eventDate, showTime, eventHour, eventMinute, eventSecond) {
    if (!startDate) return 0;

    // Create target date from the provided components
    var target = new Date(eventDate.getFullYear(), eventDate.getMonth(), eventDate.getDate(),
                         eventHour, eventMinute, eventSecond);
    var now = new Date();
    return calculateProgress(startDate, target, now);
}
