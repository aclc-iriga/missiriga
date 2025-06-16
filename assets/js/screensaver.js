// initialize screensaver variables
let idleTime = null;
let forced = false;

// initialize screensaver
const screensaver = document.getElementById("screensaver");

// show screensaver
const showScreenSaver = () => {
    if (screensaver.style.display !== "block") {
        screensaver.style.display = "block";
        window.dispatchEvent(new CustomEvent('screensaver-shown'));
    }
};

// hide screensaver
const hideScreenSaver = () => {
    if (screensaver.style.display !== "none") {
        screensaver.style.display = "none";
        window.dispatchEvent(new CustomEvent('screensaver-hidden'));
    }
};
hideScreenSaver();

// set idle time for 2 and a half minutes
const startIdleTime = () => {
    idleTime = setTimeout(() => {
        // show styles for screen saver
        showScreenSaver();
    }, 150000);
}

// clear idle time
const clearIdleTime = () => {
    clearTimeout(idleTime);
    hideScreenSaver();
    // starts idle time again after idle time is cleared
    startIdleTime();
}

// force screensaver
const forceScreensaver = () => {
    showScreenSaver();
    forced = true;
    setTimeout(() => {
        forced = false;
    }, 2400);
}

// starts idle time for screensaver
startIdleTime();

// event handlers for screensaver
window.addEventListener('mousemove', function() {
    if(!forced)
        clearIdleTime();
});
window.addEventListener('keypress', function() {
    if(!forced)
        clearIdleTime();
});