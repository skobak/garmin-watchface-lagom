using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Weather as Weather;
using Toybox.Application;
using Toybox.Time.Gregorian as Date;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Mon;
using Toybox.Application.Storage as Storage;


class skobFaceView extends WatchUi.WatchFace {
	var customFont = null;
	var customFontSmall = null;
	var customFontSuperSmall = null;
	var customFontMiddle = null;
	var customIcons = null;
	var customIconsSmall = null;
    var hourColor = 0x00FF00;
    var minutesColor = 0xFFFFFF;
    var restColor = 0xFFFFFF;
    var accentColor =0xFF5500;
	var bgColor = 0x000000;
	var globalDc=null;
    var isHideIcons = 0;
    var stepField = 0;
	var weekdayArr = [
"SUN",
"MON",
"TUE",
"WED",
"THU",
"FRI",
"SAT",
];
   
   var bias1=0;
   var bias2=0;
   var bias3= 0;
   var bias4= 0;
   var weeklyDistance = 0;
    
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
      customFont = WatchUi.loadResource(Rez.Fonts.customFont);
      customFontSmall = WatchUi.loadResource(Rez.Fonts.customFontSmall);
      customFontSuperSmall = WatchUi.loadResource(Rez.Fonts.customFontSuperSmall);
      customFontMiddle = WatchUi.loadResource(Rez.Fonts.customFontMiddle);
      customIcons = WatchUi.loadResource(Rez.Fonts.customIcon);
      customIconsSmall = WatchUi.loadResource(Rez.Fonts.customIconSmall);


      
      setLayout(Rez.Layouts.WatchFace(dc));
      globalDc = dc;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }
    
    function storeWeeklyDistance(){
 
    // Get current distnace
       var dist = Mon.getInfo().distance;
       
       var today = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    
    // Store data for each day
     var currentDistance = Application.Storage.getValue("weeklyDistance_"+today.day_of_week);
//	 if(currentDistance==null || currentDistance==0){
	    Application.Storage.setValue("weeklyDistance_"+today.day_of_week,dist);
//	  }
	  // day_of_week== 2 is monday, day_of_week [1-sun...7]
	 if (today.day_of_week==2 && dist!=null && currentDistance>dist){
	  	// Reset all params if monday distance less that already exists (meaning new data statrs)
	 resetWeeklyDistance();
	  }
	  

	  
    }
    
    function resetWeeklyDistance(){
    Application.Storage.setValue("weeklyDistance_0",0);
     Application.Storage.setValue("weeklyDistance_1",0);
      Application.Storage.setValue("weeklyDistance_2",0);
       Application.Storage.setValue("weeklyDistance_3",0);
        Application.Storage.setValue("weeklyDistance_4",0);
         Application.Storage.setValue("weeklyDistance_5",0);
          Application.Storage.setValue("weeklyDistance_6",0);
         
    }
    
        function getWeeklyDistance(){
        var distanceSumm = 0;
    var sunDistance = Application.Storage.getValue("weeklyDistance_0");
    if(sunDistance!=null){
    distanceSumm=distanceSumm+sunDistance;
    }
    
      var monDistance = Application.Storage.getValue("weeklyDistance_1");
    if(monDistance!=null){
    distanceSumm=distanceSumm+monDistance;
    }
    
    
        var tueDistance = Application.Storage.getValue("weeklyDistance_2");
    if(tueDistance!=null){
    distanceSumm=distanceSumm+tueDistance;
    }
    
            var wedDistance = Application.Storage.getValue("weeklyDistance_3");
    if(wedDistance!=null){
    distanceSumm=distanceSumm+wedDistance;
    }
    
    
            var thuDistance = Application.Storage.getValue("weeklyDistance_4");
    if(thuDistance!=null){
    distanceSumm=distanceSumm+thuDistance;
    }
    
    
    
            var friDistance = Application.Storage.getValue("weeklyDistance_5");
    if(friDistance!=null){
    distanceSumm=distanceSumm+friDistance;
    }
    
                var satDistance = Application.Storage.getValue("weeklyDistance_6");
    if(satDistance!=null){
    distanceSumm=distanceSumm+satDistance;
    }
    
    
    return distanceSumm;
    }

    // Update the view
    function onUpdate(dc) {
    
 

      hourColor = Application.getApp().getProperty("HoursColor");
      minutesColor = Application.getApp().getProperty("MinutesColor");
      restColor = Application.getApp().getProperty("RestColor");
      accentColor =Application.getApp().getProperty("AccentColor");
      bgColor=Application.getApp().getProperty("BackgroundColor");
      isHideIcons =Application.getApp().getProperty("HideIcons"); 
      stepField =Application.getApp().getProperty("StepField"); 


storeWeeklyDistance();

        drawBg(dc);
        drawDate(dc);
        drawTime(dc);
        
        if(isHideIcons == 1){
            drawIcons(dc);
        } else if(isHideIcons == 2){
            drawIconsSmall(dc);
        }
        
        drawSteps(dc,isHideIcons,stepField);
 		drawBattery(dc,isHideIcons);
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
    
    private function drawIconsSmall(dc){
        var positionY = dc.getHeight()/2-90;
        var positionX1 = dc.getWidth()/2-68; // center
        var positionX2 = dc.getWidth()/2+68; // center
        
   	    if(System.getDeviceSettings().alarmCount>=1)
   	    {
       	    var alarmIcon ='A';
    	    dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);
            dc.drawText(positionX1,positionY, customIconsSmall, alarmIcon, Graphics.TEXT_JUSTIFY_CENTER);
   	    }
   	     	
   	    if(System.getDeviceSettings().doNotDisturb)
   	    {    
   	        var doNotDisturbIcon ='B';
   	    	dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);
            dc.drawText(positionX2, positionY, customIconsSmall, doNotDisturbIcon, Graphics.TEXT_JUSTIFY_CENTER);
   	    }
    }

/*
stepField | 0 - distance dat, 1 - distance week, 2 - distance steps
*/
    private function drawSteps(dc,isHideIcons,stepField){
        var positionX = dc.getWidth()/2-25;
        var positionY = dc.getHeight()/2+85;
        var font = customFontSuperSmall;
        if(isHideIcons == 0 || isHideIcons == 2){
            positionY=positionY-35;
            positionX=positionX-10;
            font = customFontMiddle;
        }


       	var distance = Mon.getInfo().distance;
       	var distanceField = "0km";
       	
       	if(stepField==1){
       	distance = getWeeklyDistance();
       	
       	}
       	
       	if(distance!=null){
	       	distance = (distance*100).toNumber().toFloat()/100/100000;
	        distanceField = distance.format("%.2f")+"km";
 		}

        if(stepField== 2){
            distanceField= Mon.getInfo().steps;
        }
        

      	dc.setColor(accentColor,Graphics.COLOR_TRANSPARENT);
        dc.drawText(positionX,positionY, font, distanceField, Graphics.TEXT_JUSTIFY_CENTER);
    }


    private function drawBattery(dc,isHideIcons){
        var positionX = dc.getWidth()/2+25;
        var positionY = dc.getHeight()/2+85;
   	    var batteryLevel = getBatteryLevel();
        var font = customFontSuperSmall;
        if(isHideIcons == 0 || isHideIcons == 2){
            positionY=positionY-35;
            positionX=positionX+15;
            font = customFontMiddle;
        }
   	    dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);
        dc.drawText(positionX,positionY, font, batteryLevel, Graphics.TEXT_JUSTIFY_CENTER);
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
        }
        if(hours<10){
            xBias= 20;
        }
        dc.setColor(hourColor,Graphics.COLOR_TRANSPARENT);
        dc.drawText(positionXHours, positionY, customFont, hours, Graphics.TEXT_JUSTIFY_CENTER);
 	    // :
        dc.setColor(hourColor,Graphics.COLOR_TRANSPARENT);
        dc.drawText(positionXSep-xBias-3, positionY-8, customFont, ":", Graphics.TEXT_JUSTIFY_CENTER);
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
