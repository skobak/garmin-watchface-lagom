using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Weather as Weather;
using Toybox.Application;
using Toybox.Time.Gregorian as Date;
using Toybox.System as Sys;
using Toybox.Activity as Activity;
using Toybox.ActivityMonitor as Mon;
using Toybox.Application.Storage as Storage;


class skobFaceView extends WatchUi.WatchFace {
    var isBTConnected=  false;
    var notificationCount=  0;
	var customFont = null;
	var customFontSmall = null;
	var customFontSuperSmall = null;
	var customFontMiddle = null;
	var customFontTall = null;
	var customIcons = null;
	var customIconsSmall = null;
	var customIconsMaterial = null;
	var customIconsSmallMaterial = null;
    var hourColor = 0x00FF00;
    var minutesColor = 0xFFFFFF;
    var restColor = 0xFFFFFF;
    var redColor = 0xFF0000;
    var orangeColor = 0xFF5500;
    var greenColor = 0x00FF00;
    var accentColor =0xFF5500;
    var dateColor =0xFFFFFF;
	var bgColor = 0x000000;
    var weekStartDayIndex=1;
    var iconsType=0;
    var iconOne=0;
    var iconTwo=1;
    var showIconOne=true;
    var showIconTwo=true;
    var batteryIcon=false; // false is 55%, true is icon
    var showDistance=true;
	var globalDc=null;
    var isHideIcons = 0;
    var stepField = 0;
    var HR=false;
    var millitaryFormat=true;

    // var monthsEn =[
    //    "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL","AUG", "SEP", "OCT", "NOV", "DEC"
    // ]

    var monthEn =  [ "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER" ];
    var monthSE =  [ "JANUARI",	"FEBRUARI","MARS","APRIL","MAJ","JUNI","JULI","AUGUSTI","SEPTEMBER","OKTOBER","NOVEMBER","DESEMBER" ];
    var monthNor =  [ "JANUAR",	"FEBRUAR","MARS","APRIL","MAI","JUNI","JULI","AUGUST","SEPTEMBER","OKTOBER","NOVEMBER","DESEMBER" ];
    var monthSp =  ["ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE"];
    var monthIT = ["GENNAIO","FEBBRAIO","MARZO","APRILE","MAGGIO","GIUGNO","LUGLIO","AGOSTO","SETTEMBRE","OTTOBRE","NOVEMBRE","DICEMBRE"];

	var weekdayArr = [
"SUN",
"MON",
"TUE",
"WED",
"THU",
"FRI",
"SAT",
];


  var weekdayArrSe = [
     "SON","MAN","TIS","ONS","TORS","FRE","LOR"
  ];

  var weekdayArrNor = [
     "SO","MAN","TIR","ONS","TOR","FRE","LOR"
  ];
  
   var weekdayArrIT = [
     "DOM","LUN","MAR","MER","GIO","VEN","SAB"
  ];


   var weekdayArrSpanish = [
     "DOM","LUN","MAR","MIE","JUE","VIE","SAB"
  ];


  var lang =0;

   
   var bias1=0;
   var bias2=0;
   var bias3= 0;
   var bias4= 0;
   var weeklyDistance = 0;
   var metrics = 0;
   var dateFormat = 0;
    
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
      try{
      customFont = WatchUi.loadResource(Rez.Fonts.customFont);
      customFontSmall = WatchUi.loadResource(Rez.Fonts.customFontSmall);
      customFontSuperSmall = WatchUi.loadResource(Rez.Fonts.customFontSuperSmall);
      customFontMiddle = WatchUi.loadResource(Rez.Fonts.customFontMiddle);
      customFontTall = WatchUi.loadResource(Rez.Fonts.customFontTall);

      
      customIconsMaterial = WatchUi.loadResource(Rez.Fonts.customIconMaterial);
      customIconsSmallMaterial = WatchUi.loadResource(Rez.Fonts.customIconSmallMaterial);

      customIcons = WatchUi.loadResource(Rez.Fonts.customIcon);
      customIconsSmall = WatchUi.loadResource(Rez.Fonts.customIconSmall);

      
      setLayout(Rez.Layouts.WatchFace(dc));
      globalDc = dc;
      }catch( ex ) {
          System.println(ex);

}
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }
    
    function storeWeeklyDistance(){
    
 try {
    // Get current distnace
       var dist = Mon.getInfo().distance;
       
       if(dist == null){
       dist = 0;
       }
       
       var today = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    
    // Store data for each day
     var currentDistance = Application.Storage.getValue("weeklyDistance_"+today.day_of_week);

	    Application.Storage.setValue("weeklyDistance_"+today.day_of_week,dist);

	  // day_of_week== 2 is monday, day_of_week [1-sun...7]
	 if (today.day_of_week==weekStartDayIndex && dist!=null && currentDistance!=null && currentDistance>dist){
	  	// Reset all params if monday distance less that already exists (meaning new data statrs)
	 resetWeeklyDistance();
	  }
	         }  catch( ex ) {

}

	  
    }
    
    function resetWeeklyDistance(){
try {
     Application.Storage.setValue("weeklyDistance_1",0);
      Application.Storage.setValue("weeklyDistance_2",0);
       Application.Storage.setValue("weeklyDistance_3",0);
        Application.Storage.setValue("weeklyDistance_4",0);
         Application.Storage.setValue("weeklyDistance_5",0);
          Application.Storage.setValue("weeklyDistance_6",0);
          Application.Storage.setValue("weeklyDistance_7",0);
         } catch( ex ) {

}
         
    }
    
        function getWeeklyDistance(){
        var distanceSumm = 0;
        try {
    var sunDistance = Application.Storage.getValue("weeklyDistance_1");
    if(sunDistance!=null){
    distanceSumm=distanceSumm+sunDistance;
    }
    
      var monDistance = Application.Storage.getValue("weeklyDistance_2");
    if(monDistance!=null){
    distanceSumm=distanceSumm+monDistance;
    }
    
    
        var tueDistance = Application.Storage.getValue("weeklyDistance_3");
    if(tueDistance!=null){
    distanceSumm=distanceSumm+tueDistance;
    }
    
            var wedDistance = Application.Storage.getValue("weeklyDistance_4");
    if(wedDistance!=null){
    distanceSumm=distanceSumm+wedDistance;
    }
    
    
            var thuDistance = Application.Storage.getValue("weeklyDistance_5");
    if(thuDistance!=null){
    distanceSumm=distanceSumm+thuDistance;
    }
    
    
    
            var friDistance = Application.Storage.getValue("weeklyDistance_6");
    if(friDistance!=null){
    distanceSumm=distanceSumm+friDistance;
    }
    
                var satDistance = Application.Storage.getValue("weeklyDistance_7");
    if(satDistance!=null){
    distanceSumm=distanceSumm+satDistance;
    }
           } catch( ex ) {

}
    
    return distanceSumm;
    }

    // Update the view
    function onUpdate(dc) {
    

      hourColor = Application.getApp().getProperty("HoursColor");
      minutesColor = Application.getApp().getProperty("MinutesColor");
      restColor = Application.getApp().getProperty("RestColor");
      accentColor =Application.getApp().getProperty("AccentColor");
      dateColor =Application.getApp().getProperty("DateColor");
      bgColor=Application.getApp().getProperty("BackgroundColor");
      isHideIcons =Application.getApp().getProperty("HideIcons"); 
      stepField =Application.getApp().getProperty("StepField"); 
      metrics =Application.getApp().getProperty("Metrics"); 
      dateFormat =Application.getApp().getProperty("DateFormat"); 
      lang =Application.getApp().getProperty("Lang"); 
      HR =Application.getApp().getProperty("HR"); 
      HR = false;
      millitaryFormat =Application.getApp().getProperty("MillitaryFormat"); 
      weekStartDayIndex =Application.getApp().getProperty("WeekStart");
      iconsType =Application.getApp().getProperty("IconsType");
      iconOne =Application.getApp().getProperty("IconOne");
      iconTwo =Application.getApp().getProperty("IconTwo");
      showIconOne =Application.getApp().getProperty("ShowIconOne");
      showIconTwo =Application.getApp().getProperty("ShowIconTwo");
      batteryIcon =Application.getApp().getProperty("BatteryIcon");
      showDistance =Application.getApp().getProperty("ShowDistance");
      isBTConnected= Sys.getDeviceSettings().phoneConnected;
      notificationCount= Sys.getDeviceSettings().notificationCount;

        storeWeeklyDistance();

        drawBg(dc);
        drawDate(dc);
        drawTime(dc);
        
        if(isHideIcons == 1){
            drawIcons(dc);
        } else if(isHideIcons == 2){
            drawIconsSmall(dc);
        }else{
         if(HR){
           var hr = getHeatRate();
           	dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2+90, customFontSuperSmall, hr, Graphics.TEXT_JUSTIFY_CENTER);
}
}
       if(showDistance){ 
        drawSteps(dc,isHideIcons,stepField);
       }
 		drawBattery(dc,isHideIcons,showDistance);
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
 		dc.setColor(dateColor,Graphics.COLOR_TRANSPARENT);
        dc.drawText(positionX, positionY, customFontTall, dateString, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawIcon(x,y,font,dc,iconNumber){
        // 0 - alarm, 1-dnd, 2-notification count, 3 - connectivity
        var iconNum=0;
        if(iconNumber==1){
            iconNum=iconOne;
        }
        else if(iconNumber==2){
            iconNum=iconTwo;
        }
        if(iconNum==0){
            if(System.getDeviceSettings().alarmCount>=1)
   	        {
       	      var alarmIcon ='A';
    	      dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);
              dc.drawText(x,y, font, alarmIcon, Graphics.TEXT_JUSTIFY_CENTER);
   	        }
   	    }
        else if(iconNum==1){
            if(System.getDeviceSettings().doNotDisturb)
   	        {    
   	            var doNotDisturbIcon ='B';
   	    	    dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);
                dc.drawText(x, y, font, doNotDisturbIcon, Graphics.TEXT_JUSTIFY_CENTER);
   	        }
   	    }
        else if(iconNum==2){
            if(notificationCount>0)
   	        {    
   	            var messageIcon ='E';
   	    	    dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);
                dc.drawText(x, y, font, messageIcon, Graphics.TEXT_JUSTIFY_CENTER);
   	        }
   	    }
        else if(iconNum==3){
            if(isBTConnected)
   	        {    
   	            var bluetoothIcon ='C';
   	    	    dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);
                dc.drawText(x, y, font, bluetoothIcon, Graphics.TEXT_JUSTIFY_CENTER);
   	        }
            else
   	        {    
   	            var bluetoothIcon ='D';
   	    	    dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);
                dc.drawText(x, y, font, bluetoothIcon, Graphics.TEXT_JUSTIFY_CENTER);
   	        }
   	    }
    }

    private function drawIcons(dc){
        var positionY = dc.getHeight()/2+58;
        var positionX1 = dc.getWidth()/2-20; // center
        var positionX2 = dc.getWidth()/2+20; // center
        var bias =0;
        if(HR){
            bias=25;
        }
        var font = customIconsMaterial;
        if(iconsType==1){
            font = customIcons;
        }
        // Icons one and two placeholders
        if(showIconOne){
        drawIcon(positionX1-bias,positionY,font,dc,1);
        }
        if(showIconTwo){
        drawIcon(positionX2+bias,positionY,font,dc,2);
        }

        if(HR){
           var hr = getHeatRate();
           	dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);
            dc.drawText(positionX2-20, positionY-15, customFontSmall, hr, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
    
    private function drawIconsSmall(dc){
        var positionY = dc.getHeight()/2-86;
        var positionX1 = dc.getWidth()/2-67; // center
        var positionX2 = dc.getWidth()/2+67; // center

          var font = customIconsSmallMaterial;
        if(iconsType==1){
            font = customIconsSmall;
        }

if(showIconOne){
        drawIcon(positionX1,positionY,font,dc,1);
}
if(showIconTwo){
        drawIcon(positionX2,positionY,font,dc,2);
}
           if(HR){
           var hr = getHeatRate();
           	dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2+90, customFontSuperSmall, hr, Graphics.TEXT_JUSTIFY_CENTER);
}
    }

/*
stepField | 0 - distance dat, 1 - distance week, 2 - distance steps
*/
    private function drawSteps(dc,isHideIcons,stepField){
        var positionX = dc.getWidth()/2-25;
        var positionY = dc.getHeight()/2+85;
        var prefix = "km";
        if(metrics==1){
            prefix="mil";
        }
        var font = customFontSuperSmall;
        if(isHideIcons == 0 || isHideIcons == 2){
            positionY=positionY-38;
            positionX=positionX-10;
            font = customFontMiddle;
               if(batteryIcon==true){
             positionX = dc.getWidth()/2;
                 } 
        }


       	var distance = Mon.getInfo().distance;

        if(metrics==1){
            distance=distance*0.62137;
        }
       	var steps = Mon.getInfo().steps;

       	var distanceField = "0"+prefix;
       	
       	if(stepField==1){
       	distance = getWeeklyDistance();
       	
       	}
       	
       	if(distance!=null){
	       	distance = (distance*100).toNumber().toFloat()/100/100000;
	        distanceField = distance.format("%.2f")+prefix;
 		}

        if(stepField== 2){
        if(steps==null){
        distanceField="0";
        }else{
            distanceField= steps;
            }
        }

     

      	dc.setColor(accentColor,Graphics.COLOR_TRANSPARENT);
        dc.drawText(positionX,positionY, font, distanceField, Graphics.TEXT_JUSTIFY_CENTER);
    }


    private function drawBattery(dc,isHideIcons,showDistance){
        var positionX = dc.getWidth()/2+25;
        var positionY = dc.getHeight()/2+85;
   	    var batteryLevel = getBatteryLevel();
        var font = customFontSuperSmall;
        if(batteryIcon==true){
            positionY=positionY+5;
            font = customIconsSmallMaterial;
             if(iconsType==1){
                  font = customIconsSmall;
              }
        }
        if(isHideIcons == 0 || isHideIcons == 2){
            positionY=positionY-38;
            positionX=positionX+15;
            font = customFontMiddle;
           
            if(batteryIcon==true){
                    positionX = dc.getWidth()/2;
                  positionY=positionY+37;
                  if(showDistance==false){
                      positionY=positionY-30;
                  }
              font = customIconsMaterial;
              if(iconsType==1){
                  font = customIcons;
              }
            }
        }
        if(showDistance==false){
            positionX=dc.getWidth()/2;
        }
   	    dc.setColor(restColor,Graphics.COLOR_TRANSPARENT);

       if(batteryIcon==true){
           batteryLevel = getBatteryIcon();
            if(batteryLevel.equals("5")){
                dc.setColor(orangeColor,Graphics.COLOR_TRANSPARENT);
           }
           if(batteryLevel.equals("6")){
                dc.setColor(redColor,Graphics.COLOR_TRANSPARENT);
           }
       }   
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
        if (!millitaryFormat || !System.getDeviceSettings().is24Hour) {
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
         var dayOfTheWeek = getDayOfAWeekName(today.day_of_week);
         var monthName = getMonthName(today.month);

         var dateString = dayOfTheWeek+" "+Lang.format(
    "$1$.$2$",
    [
        today.day,
        today.month,
    ]
    );

    

     
if(dateFormat==1){
  dateString = dayOfTheWeek+" "+Lang.format(
    "$1$.$2$",
    [
       
        today.month,
         today.day,
    ]
    );
}
else if(dateFormat==2){
  dateString = dayOfTheWeek+" "+Lang.format(
    "$1$/$2$",
    [
          today.day,
        today.month,
      
    ]
    );
}
else if(dateFormat==3){
  dateString = dayOfTheWeek+" "+Lang.format(
    "$1$/$2$",
    [
          today.month,
          today.day,
      
      
    ]
    );
}
else if(dateFormat==4){
  dateString = Lang.format(
    "$1$/$2$/$3$",
    [
          today.month,
          today.day,
      today.year,
      
    ]
    );
}
else if(dateFormat==5){
  dateString = Lang.format(
    "$1$/$2$/$3$",
    [
          today.day,
          today.month,
      today.year,
      
    ]
    );
}

else if(dateFormat==6){
  dateString = Lang.format(
    "$1$",
    [
          today.day,
    ]
    )+" "+monthName.substring(0,3);
}

else if(dateFormat==7){
  dateString = Lang.format(
    "$1$",
    [
          today.day,
    ]
    )+" "+monthName;
}
        return dateString;
    }
    
    private function getDayOfAWeekName(number){
        if(lang==0){
    	return weekdayArr[number-1];
        }
        if(lang==2){
        return weekdayArrIT[number-1];
        }
        if(lang==3){
        return weekdayArrSpanish[number-1];
        }
        if(lang==4){
        return weekdayArrSe[number-1];
        }
        return weekdayArrNor[number-1];
    }

    private function getMonthName(number){
        if(lang==0){
    	return monthEn[number-1];
        }
        if(lang==2){
        return monthIT[number-1];
        }
        if(lang==3){
        return monthSp[number-1];
        }
        if(lang==4){
        return monthSE[number-1];
        }
        return monthNor[number-1];
    }
    
    private function getBatteryLevel() {
        var battery = Sys.getSystemStats().battery;				     
	    return battery.format("%d")+"%";	
    }

      private function getBatteryIcon() {
        var battery = Sys.getSystemStats().battery;	  
        if(battery>=95){
            return "0";
        }else if (battery>=80 && battery<95){
            return "1";
        }else if (battery>=60 && battery<80){
            return "2";
        }else if (battery>=50 && battery<60){
            return "3";
        }else if (battery>=30 && battery<50){
            return "4";
        }else if (battery>=10 && battery<30){
            return "5";
        }else if (battery>=0 && battery<10){
            return "6";
        }  
        return "7";
    }

    private function getHeatRate(){
        var HRH=Mon.getHeartRateHistory(1, true);
     var HRS=HRH.next();
    return HRS.heartRate;
    }
}