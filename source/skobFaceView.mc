using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Weather as Weather;
using Toybox.Application;
using Toybox.Time.Gregorian as Date;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Mon;


class skobFaceView extends WatchUi.WatchFace {
	var customFont = null;
	var customFontSmall = null;
	var customFontSuperSmall = null;
	var customIcons = null;
    var hourColor = 0x55aa00;
    var minutesColor = 0xffffff;
    var restColor = 0xffffff;
    var accentColor =0xffaa00;
	var bgColor = 0x000000;
	var globalDc=null;
    var isHideIcons = false;
	var weekdayArr = [
"SUN",
"MON",
"TUE",
"WED",
"THU",
"FRI",
"SAT",
];
    
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
      customFont = WatchUi.loadResource(Rez.Fonts.customFont);
      customFontSmall = WatchUi.loadResource(Rez.Fonts.customFontSmall);
      customFontSuperSmall = WatchUi.loadResource(Rez.Fonts.customFontSuperSmall);
      customIcons = WatchUi.loadResource(Rez.Fonts.customIcon);


      
      setLayout(Rez.Layouts.WatchFace(dc));
      globalDc = dc;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {

      hourColor = Application.getApp().getProperty("HoursColor");
      minutesColor = Application.getApp().getProperty("MinutesColor");
      restColor = Application.getApp().getProperty("RestColor");
      accentColor =Application.getApp().getProperty("AccentColor");
      bgColor=Application.getApp().getProperty("BackgroundColor");
      isHideIcons =Application.getApp().getProperty("HideIcons"); 


        drawBg(dc);
        drawDate(dc);
        drawTime(dc);
        if(!isHideIcons){
            drawIcons(dc);
        }
        drawSteps(dc);
 		drawBattery(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
    


    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    
    
    private function drawBg(dc){
        dc.setColor(bgColor, bgColor);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
    }

    private function drawDate(dc){
        var positionY = dc.getHeight()/2-108;
        var positionX = dc.getWidth()/2; // center
  		var dateString = getDateString();
 		dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);
        dc.drawText(positionX, positionY, customFontSmall, dateString, Graphics.TEXT_JUSTIFY_CENTER);
    }


    private function drawIcons(dc){
        var positionY = dc.getHeight()/2+58;
        var positionX1 = dc.getWidth()/2-20; // center
        var positionX2 = dc.getWidth()/2+20; // center
        
   	    if(System.getDeviceSettings().alarmCount>=1)
   	    {
       	    var alarmIcon ='A';
    	    dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);
            dc.drawText(positionX1,positionY, customIcons, alarmIcon, Graphics.TEXT_JUSTIFY_CENTER);
   	    }
   	     	
   	    if(System.getDeviceSettings().doNotDisturb)
   	    {    
   	        var doNotDisturbIcon ='B';
   	    	dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);
            dc.drawText(positionX2, positionY, customIcons, doNotDisturbIcon, Graphics.TEXT_JUSTIFY_CENTER);
   	    }
    }

    private function drawSteps(dc){
        var positionX = dc.getWidth()/2-25;
        var positionY = dc.getHeight()/2+85;
       	var steps = (Mon.getInfo().steps/1000);
        var distanceField = steps.format("%.1f")+"km";
 
      	dc.setColor(accentColor,Graphics.COLOR_TRANSPARENT);
        dc.drawText(positionX,positionY, customFontSuperSmall, distanceField, Graphics.TEXT_JUSTIFY_CENTER);
    }


    private function drawBattery(dc){
        var positionX = dc.getWidth()/2+25;
        var positionY = dc.getHeight()/2+85;
   	    var batteryLevel = getBatteryLevel();
   	    dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);
        dc.drawText(positionX,positionY, customFontSuperSmall, batteryLevel, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawTime(dc) {
        var xBias=0;
        var positionXHours = dc.getWidth()/2-60;
        var positionXSep = dc.getWidth()/2;
        var positionXMinutes = dc.getWidth()/2+60;
        var positionY = dc.getHeight()/2-118;
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            // if (Application.getApp().getProperty("UseMilitaryFormat")) {
            //     timeFormat = "$1$$2$";
            //     hours = hours.format("%02d");
            // }
        }
        // var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

   	    // Hours

           if(hours<10){
              xBias= 20;
           }
        dc.setColor(hourColor,Graphics.COLOR_TRANSPARENT);
        dc.drawText(positionXHours, positionY, customFont, hours, Graphics.TEXT_JUSTIFY_CENTER);
 	    // :
        dc.setColor(hourColor,Graphics.COLOR_TRANSPARENT);
        dc.drawText(positionXSep-xBias-4, positionY-8, customFont, ":", Graphics.TEXT_JUSTIFY_CENTER);
 	    // Minutes
        dc.setColor(minutesColor,Graphics.COLOR_TRANSPARENT);
        dc.drawText(positionXMinutes-xBias, positionY, customFont,  clockTime.min.format("%02d"), Graphics.TEXT_JUSTIFY_CENTER);
    }


    // Helper functions
    private function getDateString() {      
         var today = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
         var dateString = Lang.format(
    "$1$.$2$",
    [
        today.day,
        today.month,
    ]
    );

        var dayOfTheWeek = getDayOfAWeekName(today.day_of_week);
        return dayOfTheWeek+" "+dateString;
    }
    
    private function getDayOfAWeekName(number){
    	return weekdayArr[number-1];
    }
    
    private function getBatteryLevel() {
        var battery = Sys.getSystemStats().battery;				
	    var batteryDisplay = View.findDrawableById("BatteryDisplay");      
	    return battery.format("%d")+"%";	
    }
    
 
}
