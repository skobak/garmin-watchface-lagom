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
using Toybox.UserProfile as UserProfile;
using Toybox.Application.Storage as Storage;
const INTEGER_FORMAT = "%d";

class skobFaceView extends WatchUi.WatchFace {
  var isBTConnected = false;
  var notificationCount = 0;
  var customFont = null;
  var customFontAOD =
      null;  // Special font for Always on display (small for allocat 10% of the
             // pixels (VENU requirementa and amoled displays in general))
  var customFontSmallPadding = 0;
  var customFontMiddlePadding = 0;
  var customFontDatePadding = 0;
  var customFontTimePadding = 0;
  var batteryPadding = 0;
  var customLayour2Padding = 0;
  var layer0Ybias = 0;
  var layer1Ybias = 0;
  var layer2Ybias = 0;
  var layer3Ybias = 0;
  var layer4Ybias = 0;
  var smallIconBias = 0;
  var smallIconXBias = 0;
  var customFontBig = null;
  var customFontHuge = null;
  var customFontSmall = null;
  var customFontSuperSmall = null;
  var customFontMiddle = null;
  var customFontDate = null;
  var customFontDateBig = null;
  var customFontDateHuge = null;
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
  var accentColor = 0xFF5500;
  var dateColor = 0xFFFFFF;
  var bgColor = 0x000000;
  var weekStartDayIndex = 1;
  var iconsType = 0;
  var iconOne = 0;
  var iconTwo = 1;
  var age = 30;
  var showIconOne = true;
  var showIconTwo = true;
  var batteryIcon = false;  // false is 55%, true is icon
  var showDistance = true;
  var showWeekNumber = false;
  var isHideIcons = 0;
  var stepField = 0;
  var HR = false;
  var HRColoring = true;
  var millitaryFormat = true;
  var noSeparation = false;
  var leadingZero = false;

  var monthEn = [
    "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST",
    "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"
  ];
  var monthSE = [
    "JANUARI", "FEBRUARI", "MARS", "APRIL", "MAJ", "JUNI", "JULI", "AUGUSTI",
    "SEPTEMBER", "OKTOBER", "NOVEMBER", "DESEMBER"
  ];
  var monthNor = [
    "JANUAR", "FEBRUAR", "MARS", "APRIL", "MAI", "JUNI", "JULI", "AUGUST",
    "SEPTEMBER", "OKTOBER", "NOVEMBER", "DESEMBER"
  ];
  var monthSp = [
    "ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", "AGOSTO",
    "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE"
  ];
  var monthIT = [
    "GENNAIO", "FEBBRAIO", "MARZO", "APRILE", "MAGGIO", "GIUGNO", "LUGLIO",
    "AGOSTO", "SETTEMBRE", "OTTOBRE", "NOVEMBRE", "DICEMBRE"
  ];
  var monthGE = [
    "JANUAR", "FEBRUAR", "MARZ", "APRIL", "MAI", "JUNI", "JULI", "AUGUST",
    "SEPTEMBER", "OKTOBER", "NOVEMBER", "DEZEMBER"
  ];
  var monthSL = [
    "JANUAR", "FEBRUAR", "MAREC", "APRIL", "MAJ", "JUN", "JUL", "AUGUST",
    "SEPTEMBER", "OKTOBER", "NOVEMBER", "DECEMBER"
  ];

  var WeekWord =
      [ "Week", "Uke", "Settimana", "Semana", "Vecka", "Woche", "Tyzden" ];

  var weekdayArr = [
    "SUN",
    "MON",
    "TUE",
    "WED",
    "THU",
    "FRI",
    "SAT",
  ];

  var weekdayArrSe = [ "SON", "MAN", "TIS", "ONS", "TORS", "FRE", "LOR" ];
  var weekdayArrNor = [ "SO", "MAN", "TIR", "ONS", "TOR", "FRE", "LOR" ];
  var weekdayArrIT = [ "DOM", "LUN", "MAR", "MER", "GIO", "VEN", "SAB" ];
  var weekdayArrSpanish = [ "DOM", "LUN", "MAR", "MIE", "JUE", "VIE", "SAB" ];
  var weekdayArrGerman = [ "SON", "MON", "DIE", "MIT", "DON", "FRE", "SAM" ];
  var weekdayArrSlovak = [ "NED", "PON", "UTO", "STR", "STV", "PIA", "SOB" ];

  var lang = 0;

  var bias1 = 0;
  var bias2 = 0;
  var bias3 = 0;
  var bias4 = 0;
  var weeklyDistance = 0;
  var metrics = 0;
  var dateFormat = 0;

  var aodX = 0;
  var aodMinute = 0;
  var aodNeedChangePosition = false;

  /*
  Options
  0-218
  1-240
  2-260
  3-280
  4-360
  5-390
  5-416
  Possible
  0-small,1-big,2-huge
  */
  var screenSize = 0;

  var positionYLayer0 = 0;  // Top
  var positionYLayer1 = 0;
  var positionYLayer2 = 0;
  var positionYLayer3 = 0;
  var positionYLayer4 = 0;  // Bottom
  var fontDate = null;
  var fontTime = null;
  var fontIconBig = null;
  var fontIconSmall = null;
  var fontSmall = null;
  var inLowPower = false;
  var canBurnIn = false;
  var upTop = true;

  function initialize() {
    WatchFace.initialize();
    // check if burn in protection needed
    var sSettings = Sys.getDeviceSettings();
    // first check if the setting is availe on the current device
    if (sSettings has : requiresBurnInProtection) {
      // get the state of the setting
      canBurnIn = sSettings.requiresBurnInProtection;
    }
  }

  /*
   Different screen require different fonts and so on
  */
  function defineScreenSize(dc) {
    var x = dc.getWidth();
    var y = dc.getHeight();

    if (x > 100 && x <= 230) {
      screenSize = 5;  // vivo active S small
    }
    if (x > 230 && x <= 240) {
      screenSize = 0;  // small forenummer
    }
    if (x > 240 && x < 360) {
      screenSize = 1;  // big fenix
    }
    if (x >= 360 && x < 390) {
      screenSize = 2;  // custom 360 Venu 2S
    }
    if (x >= 390) {
      screenSize = 3;  // huge Venu 2
    }
  }

  function defineFonts() {
    customFontAOD = WatchUi.loadResource(Rez.Fonts.customFontAOD);
    // customFontAOD = WatchUi.loadResource(Rez.Fonts.customFontSuperSmall);
    if (screenSize == 5) {
      customFont = WatchUi.loadResource(Rez.Fonts.customFont218);
      customFontDate = WatchUi.loadResource(Rez.Fonts.customFontDate);
      customFontMiddle = WatchUi.loadResource(Rez.Fonts.customFontDate);

      customFontSmall = WatchUi.loadResource(Rez.Fonts.customFontSmall);  // HR
      customFontSuperSmall =
          WatchUi.loadResource(Rez.Fonts.customFontSuperSmall);
      customIconsMaterial = WatchUi.loadResource(Rez.Fonts.customIconMaterial);
      customIconsSmallMaterial =
          WatchUi.loadResource(Rez.Fonts.customIconSmallMaterial);
      customIcons = WatchUi.loadResource(Rez.Fonts.customIcon);
      customIconsSmall = WatchUi.loadResource(Rez.Fonts.customIconSmall);
      // This is a area around font, so we should keep it in mind for the right
      // calculation
      customFontSmallPadding = 10;
      customFontMiddlePadding = 14;
      customFontDatePadding = 30;
      customFontTimePadding = 0;
      batteryPadding = 15;
      customLayour2Padding = 30;
      smallIconBias = 0;
      smallIconXBias = 22;
      layer0Ybias = 2;
      layer1Ybias = 3;
      layer2Ybias = 0;
      layer3Ybias = 0;
      layer4Ybias = -8;
    }
    if (screenSize == 0) {
      customFont = WatchUi.loadResource(Rez.Fonts.customFont);
      customFontDate = WatchUi.loadResource(Rez.Fonts.customFontDate);
      customFontMiddle = WatchUi.loadResource(Rez.Fonts.customFontDate);

      customFontSmall = WatchUi.loadResource(Rez.Fonts.customFontSmall);  // HR
      customFontSuperSmall =
          WatchUi.loadResource(Rez.Fonts.customFontSuperSmall);
      customIconsMaterial = WatchUi.loadResource(Rez.Fonts.customIconMaterial);
      customIconsSmallMaterial =
          WatchUi.loadResource(Rez.Fonts.customIconSmallMaterial);
      customIcons = WatchUi.loadResource(Rez.Fonts.customIcon);
      customIconsSmall = WatchUi.loadResource(Rez.Fonts.customIconSmall);
      // This is a area around font, so we should keep it in mind for the right
      // calculation
      customFontSmallPadding = 10;
      customFontMiddlePadding = 14;
      customFontDatePadding = 30;
      customFontTimePadding = 0;
      batteryPadding = 15;
      customLayour2Padding = 30;
      smallIconBias = 0;
      smallIconXBias = 22;
      layer0Ybias = 5;
      layer1Ybias = 6;
      layer2Ybias = 0;
      layer3Ybias = 0;
      layer4Ybias = -5;
    }
    if (screenSize == 1) {
      customFont = WatchUi.loadResource(Rez.Fonts.customFontBig);
      customFontDate = WatchUi.loadResource(Rez.Fonts.customFontDateBig);
      customFontMiddle = WatchUi.loadResource(Rez.Fonts.customFontDateBig);

      customFontSmall = WatchUi.loadResource(Rez.Fonts.customFontSmall);
      customFontSuperSmall =
          WatchUi.loadResource(Rez.Fonts.customFontSuperSmallBig);
      customIconsMaterial =
          WatchUi.loadResource(Rez.Fonts.customIconMaterialBig);
      customIconsSmallMaterial =
          WatchUi.loadResource(Rez.Fonts.customIconSmallMaterialBig);
      customIcons = WatchUi.loadResource(Rez.Fonts.customIconBig);
      customIconsSmall = WatchUi.loadResource(Rez.Fonts.customIconSmallBig);
      // This is a area around font, so we should keep it in mind for the right
      // calculation
      customFontSmallPadding = 5;
      customFontMiddlePadding = 14;
      customFontDatePadding = 30;
      customFontTimePadding = 0;
      batteryPadding = 11;
      customLayour2Padding = 30;
      smallIconBias = -7;

      smallIconXBias = 25;
      layer0Ybias = 5;
      layer1Ybias = 7;
      layer2Ybias = 0;
      layer3Ybias = -3;
      layer4Ybias = 0;
    }
    if (screenSize == 2) {  // 360
      customFont = WatchUi.loadResource(Rez.Fonts.customFont360);
      customFontDate = WatchUi.loadResource(Rez.Fonts.customFontDateBig);
      customFontMiddle = WatchUi.loadResource(Rez.Fonts.customFontDateBig);

      customFontSmall = WatchUi.loadResource(Rez.Fonts.customFontSmall);
      customFontSuperSmall =
          WatchUi.loadResource(Rez.Fonts.customFontSuperSmallBig);
      customIconsMaterial =
          WatchUi.loadResource(Rez.Fonts.customIconMaterialBig);
      customIconsSmallMaterial =
          WatchUi.loadResource(Rez.Fonts.customIconSmallMaterialBig);
      customIcons = WatchUi.loadResource(Rez.Fonts.customIconBig);
      customIconsSmall = WatchUi.loadResource(Rez.Fonts.customIconSmallBig);
      // This is a area around font, so we should keep it in mind for the right
      // calculation
      customFontSmallPadding = 5;
      customFontMiddlePadding = 14;
      customFontDatePadding = 30;
      customFontTimePadding = 0;
      batteryPadding = 11;
      customLayour2Padding = 30;
      smallIconBias = -7;
      smallIconXBias = 30;
      layer0Ybias = 0;
      layer1Ybias = 5;
      layer2Ybias = 0;
      layer3Ybias = -3;
      layer4Ybias = 0;
    }
    if (screenSize == 3) {
      customFont = WatchUi.loadResource(Rez.Fonts.customFontHuge);
      customFontDate = WatchUi.loadResource(Rez.Fonts.customFontDateHuge);
      customFontMiddle = WatchUi.loadResource(Rez.Fonts.customFontDateHuge);

      customFontSmall = WatchUi.loadResource(Rez.Fonts.customFontSmall);
      customFontSuperSmall =
          WatchUi.loadResource(Rez.Fonts.customFontSuperSmallHuge);
      customIconsMaterial =
          WatchUi.loadResource(Rez.Fonts.customIconMaterialHuge);
      customIconsSmallMaterial =
          WatchUi.loadResource(Rez.Fonts.customIconSmallMaterialHuge);
      customIcons = WatchUi.loadResource(Rez.Fonts.customIconHuge);
      customIconsSmall = WatchUi.loadResource(Rez.Fonts.customIconSmallHuge);
      // This is a area around font, so we should keep it in mind for the right
      // calculation
      customFontSmallPadding = 5;
      customFontMiddlePadding = 14;
      customFontDatePadding = 30;
      customFontTimePadding = 0;
      batteryPadding = 13;
      customLayour2Padding = 60;

      smallIconXBias = 35;

      layer0Ybias = -4;
      layer1Ybias = -3;
      layer2Ybias = 0;
      layer3Ybias = 0;
      layer4Ybias = -2;
    }
  }

  function defineLayouts(dc) {
    var centerX = 0;
    var centerY = dc.getHeight() / 2;
    var timeFontHeight = dc.getFontHeight(customFont);
    var dateFontHeight = dc.getFontHeight(customFontDate);
    var superSmallFontHeight = dc.getFontHeight(customFontSuperSmall);
    positionYLayer0 = centerY - timeFontHeight / 2 - dateFontHeight / 2 -
                      customFontDatePadding - superSmallFontHeight / 2 +
                      layer0Ybias;  // Top
    positionYLayer1 = centerY - timeFontHeight / 2 - dateFontHeight / 2 -
                      customFontDatePadding + layer1Ybias;  // Top
    positionYLayer2 = centerY - timeFontHeight / 2 + layer2Ybias;
    positionYLayer3 = centerY + timeFontHeight / 2 + 5 + layer3Ybias;
    positionYLayer4 = centerY + timeFontHeight / 2 + customLayour2Padding +
                      layer4Ybias;  // Bottom
  }

  // Load your resources here
  function onLayout(dc) {
    try {
      defineScreenSize(dc);
      defineFonts();
      defineLayouts(dc);
      setLayout(Rez.Layouts.WatchFace(dc));
    } catch (ex) {
      System.println(ex);
    }
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() {}

  function storeWeeklyDistance() {
    try {
      // Get current distnace
      var dist = Mon.getInfo().distance;

      if (dist == null) {
        dist = 0;
      }

      var today = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);

      // Store data for each day
      var currentDistance =
          Application.Storage.getValue("weeklyDistance_" + today.day_of_week);

      Application.Storage.setValue("weeklyDistance_" + today.day_of_week, dist);

      // day_of_week== 2 is monday, day_of_week [1-sun...7]
      if (today.day_of_week == weekStartDayIndex && dist != null &&
          currentDistance != null && currentDistance > dist) {
        // Reset all params if monday distance less that already exists (meaning
        // new data statrs)
        resetWeeklyDistance();
      }
    } catch (ex) {
    }
  }

  function resetWeeklyDistance() {
    try {
      Application.Storage.setValue("weeklyDistance_1", 0);
      Application.Storage.setValue("weeklyDistance_2", 0);
      Application.Storage.setValue("weeklyDistance_3", 0);
      Application.Storage.setValue("weeklyDistance_4", 0);
      Application.Storage.setValue("weeklyDistance_5", 0);
      Application.Storage.setValue("weeklyDistance_6", 0);
      Application.Storage.setValue("weeklyDistance_7", 0);
    } catch (ex) {
    }
  }

  function getWeeklyDistance() {
    var distanceSumm = 0;
    try {
      var sunDistance = Application.Storage.getValue("weeklyDistance_1");
      if (sunDistance != null) {
        distanceSumm = distanceSumm + sunDistance;
      }

      var monDistance = Application.Storage.getValue("weeklyDistance_2");
      if (monDistance != null) {
        distanceSumm = distanceSumm + monDistance;
      }

      var tueDistance = Application.Storage.getValue("weeklyDistance_3");
      if (tueDistance != null) {
        distanceSumm = distanceSumm + tueDistance;
      }

      var wedDistance = Application.Storage.getValue("weeklyDistance_4");
      if (wedDistance != null) {
        distanceSumm = distanceSumm + wedDistance;
      }

      var thuDistance = Application.Storage.getValue("weeklyDistance_5");
      if (thuDistance != null) {
        distanceSumm = distanceSumm + thuDistance;
      }

      var friDistance = Application.Storage.getValue("weeklyDistance_6");
      if (friDistance != null) {
        distanceSumm = distanceSumm + friDistance;
      }

      var satDistance = Application.Storage.getValue("weeklyDistance_7");
      if (satDistance != null) {
        distanceSumm = distanceSumm + satDistance;
      }
    } catch (ex) {
    }

    return distanceSumm;
  }

 private
  funtion setSettings() {
    hourColor = Application.getApp().getProperty("HoursColor");
    minutesColor = Application.getApp().getProperty("MinutesColor");
    restColor = Application.getApp().getProperty("RestColor");
    accentColor = Application.getApp().getProperty("AccentColor");
    dateColor = Application.getApp().getProperty("DateColor");
    bgColor = Application.getApp().getProperty("BackgroundColor");
    isHideIcons = Application.getApp().getProperty("HideIcons");
    stepField = Application.getApp().getProperty("StepField");
    metrics = Application.getApp().getProperty("Metrics");
    dateFormat = Application.getApp().getProperty("DateFormat");
    lang = Application.getApp().getProperty("Lang");
    HR = Application.getApp().getProperty("HR");
    HRColoring = Application.getApp().getProperty("HRColoring");
    millitaryFormat = Application.getApp().getProperty("MillitaryFormat");
    noSeparation = Application.getApp().getProperty("NoSeparation");
    leadingZero = Application.getApp().getProperty("LeadingZero");
    weekStartDayIndex = Application.getApp().getProperty("WeekStart");
    iconsType = Application.getApp().getProperty("IconsType");
    iconOne = Application.getApp().getProperty("IconOne");
    iconTwo = Application.getApp().getProperty("IconTwo");
    age = Application.getApp().getProperty("Age");
    showIconOne = Application.getApp().getProperty("ShowIconOne");
    showIconTwo = Application.getApp().getProperty("ShowIconTwo");
    batteryIcon = Application.getApp().getProperty("BatteryIcon");
    showDistance = Application.getApp().getProperty("ShowDistance");
    showWeekNumber = Application.getApp().getProperty("ShowWeek");
    isBTConnected = Sys.getDeviceSettings().phoneConnected;
    notificationCount = Sys.getDeviceSettings().notificationCount;
  }
  // Update the view
  function onUpdate(dc) {
    setSettings();
    storeWeeklyDistance();

    // Only for OLED displays in low power mode
    if (inLowPower && canBurnIn) {
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
      dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
      drawTimeAOD(dc);
    } else {
      drawBg(dc);
      drawDate(dc);
      drawTime(dc);

      if (isHideIcons == 1) {
        drawIcons(dc);
      } else if (isHideIcons == 2) {
        drawIconsSmall(dc);
      }

      if (HR) {
        drawHR(dc);
      }

      if (showDistance) {
        drawDistance(dc, isHideIcons, stepField);
      }

      drawBattery(dc, isHideIcons, showDistance);

      if (showWeekNumber) {
        drawWeekNumber(dc);
      }
    }
  }

  function drawWeekNumber(dc) {
    var weekNumber = getWeekNumber();

    var positionY = 0;
    var positionX = dc.getWidth() / 2;  // center
    dc.setColor(dateColor, Graphics.COLOR_TRANSPARENT);
    // dc.setColor(dateColor,Graphics.COLOR_TRANSPARENT);

    dc.drawText(positionX, positionYLayer0, customFontSuperSmall,
                " " + WeekWord[lang] + " " + weekNumber + " ",
                Graphics.TEXT_JUSTIFY_CENTER);
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() {}

  // The user has just looked at their watch. Timers and animations may be
  // started here.
  function onExitSleep() {
    inLowPower = false;
    WatchUi.requestUpdate();
  }

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() {
    inLowPower = true;
    WatchUi.requestUpdate();
  }

 private
  function drawHR(dc) {
    var biasXRight = 0;
    var hr = getHR();
    var color = getHRColorByValue(hr);
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);

    var positionY = positionYLayer3 - customFontMiddlePadding;
    var font = customFontMiddle;

    if (showDistance && isHideIcons != 1) {
      var HRwidth = dc.getTextWidthInPixels(hr, font);
      biasXRight = biasXRight + HRwidth;
    }

    dc.drawText(dc.getWidth() / 2 + biasXRight, positionY, font, hr,
                Graphics.TEXT_JUSTIFY_CENTER);
  }

 private
  function getHRColorByValue(hr) {
    var max = 220 - age;
    if (hr.equals("")) {
      return restColor;
    }

    if (HRColoring == false) {
      return restColor;
    }

    hr = hr.toNumber();
    // zone 1
    if (hr <= max * 0.7) {
      return 0xFFFFFF;
    }
    // zone 2
    if (hr > max * 0.7 && hr <= max * 0.8) {
      return 0x00AAFF;
    }
    // zone 3
    if (hr > max * 0.8 && hr <= max * 0.9) {
      return 0x00FF00;
    }
    // zone 4
    if (hr > max * 0.9 && hr <= max) {
      return 0xFFFF00;
    }
    // zone 5
    if (hr > max) {
      return 0xFF0000;
    }
    return restColor;
  }

 private
  function drawBg(dc) {
    dc.setColor(bgColor, bgColor);
    dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
  }

 private
  function drawDate(dc) {
    // define font-size depend on screen size
    var fontHeight = dc.getFontHeight(customFont);
    var positionY = dc.getHeight() / 2 - fontHeight / 2;

    // var positionY = dc.getHeight()/2-108;
    var positionX = dc.getWidth() / 2;  // center
    var dateString = getDateString();
    dc.setColor(dateColor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(positionX, positionYLayer1, customFontDate, dateString,
                Graphics.TEXT_JUSTIFY_CENTER);
  }

 private
  function drawIcon(x, y, font, dc, iconNumber) {
    // 0 - alarm, 1-dnd, 2-notification count, 3 - connectivity
    var iconNum = 0;
    if (iconNumber == 1) {
      iconNum = iconOne;
    } else if (iconNumber == 2) {
      iconNum = iconTwo;
    }
    if (iconNum == 0) {
      if (System.getDeviceSettings().alarmCount >= 1) {
        var alarmIcon = 'A';
        dc.setColor(restColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, alarmIcon, Graphics.TEXT_JUSTIFY_CENTER);
      }
    } else if (iconNum == 1) {  // DND
      if (System.getDeviceSettings().doNotDisturb) {
        var doNotDisturbIcon = 'B';
        dc.setColor(restColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, doNotDisturbIcon, Graphics.TEXT_JUSTIFY_CENTER);
      }
    } else if (iconNum == 2) {
      if (notificationCount > 0) {
        var messageIcon = 'E';
        dc.setColor(restColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, messageIcon, Graphics.TEXT_JUSTIFY_CENTER);
      }
    } else if (iconNum == 3) {  // Connectivity
      if (isBTConnected) {
        var bluetoothIcon = 'C';
        dc.setColor(restColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, bluetoothIcon, Graphics.TEXT_JUSTIFY_CENTER);
      } else {
        var bluetoothIcon = 'D';
        dc.setColor(restColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, bluetoothIcon, Graphics.TEXT_JUSTIFY_CENTER);
      }
    }
  }

 private
  function drawIcons(dc) {
    var positionX1 = dc.getWidth() / 2;  // center
    var positionX2 = dc.getWidth() / 2;  // center
    var bias = 0;
    if (HR) {
      bias = dc.getTextWidthInPixels("555", customFontSmall);
    }
    var font = customIconsMaterial;
    if (iconsType == 1) {
      font = customIcons;
    }

    var fontWidth = dc.getTextWidthInPixels("A", font);
    // Icons one and two placeholders
    if (showIconOne) {
      drawIcon(positionX1 - fontWidth / 2 - bias / 2 - 8, positionYLayer3, font,
               dc, 1);
    }
    if (showIconTwo) {
      drawIcon(positionX2 + fontWidth / 2 + bias / 2 + 8, positionYLayer3, font,
               dc, 2);
    }
  }

 private
  function drawIconsSmall(dc) {
    var widthOfDate = dc.getTextWidthInPixels(getDateString(), customFontDate);
    var positionX1 =
        dc.getWidth() / 2 - widthOfDate / 2 - smallIconXBias;  // left icon
    var positionX2 =
        dc.getWidth() / 2 + widthOfDate / 2 + smallIconXBias;  // right icon

    var font = customIconsSmallMaterial;
    if (iconsType == 1) {
      font = customIconsSmall;
    }

    var fontHeight = dc.getFontHeight(font);

    if (showIconOne) {
      drawIcon(positionX1, positionYLayer1 + fontHeight + smallIconBias, font,
               dc, 1);
    }
    if (showIconTwo) {
      drawIcon(positionX2, positionYLayer1 + fontHeight + smallIconBias, font,
               dc, 2);
    }
  }

 private
  function getDistanceData() {
    var prefix = "km";
    if (metrics == 1) {
      prefix = "mil";
    }
    var distance = Mon.getInfo().distance;
    if (metrics == 1) {
      distance = distance * 0.62137;
    }
    var steps = Mon.getInfo().steps;
    var distanceField = "0" + prefix;

    if (stepField == 1) {
      distance = getWeeklyDistance();
    }

    if (distance != null) {
      distance = (distance * 100).toNumber().toFloat() / 100 / 100000;
      distanceField = distance.format("%.2f") + prefix;
    }

    if (stepField == 2) {
      if (steps == null) {
        distanceField = "0";
      } else {
        distanceField = steps;
      }
    }
    return distanceField;
  }
  /*
  stepField | 0 - distance dat, 1 - distance week, 2 - distance steps
  */
 private
  function drawDistance(dc, isHideIcons, stepField) {
    var positionY = positionYLayer3 - customFontMiddlePadding;
    var font = customFontSuperSmall;
    if (isHideIcons != 1) {
      font = customFontMiddle;
    } else {
      positionY = positionYLayer4 + customFontSmallPadding;
    }
    var biasXLeft = 0;

    var distanceField = getDistanceData();

    var widthOfDistance = dc.getTextWidthInPixels(distanceField + "", font);
    biasXLeft = biasXLeft + widthOfDistance / 2;

    if (isHideIcons != 1 && !HR) {
      biasXLeft = 0;
    }
    dc.setColor(accentColor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(dc.getWidth() / 2 - biasXLeft, positionY, font, distanceField,
                Graphics.TEXT_JUSTIFY_CENTER);
  }

 private
  function drawBattery(dc, isHideIcons, showDistance) {
    var xBias = 0;
    var batteryLevel = getBatteryLevel();
    var font = customFontSuperSmall;
    var positionY = positionYLayer4 + customFontSmallPadding;
    var dataWidth = dc.getTextWidthInPixels(batteryLevel, font);

    if (isHideIcons == 1 && showDistance) {
      xBias = xBias + dataWidth;
    }

    // if icon
    dc.setColor(restColor, Graphics.COLOR_TRANSPARENT);
    if (batteryIcon) {
      // get certain Icon
      batteryLevel = getBatteryIcon();
      if (batteryLevel.equals("5")) {
        dc.setColor(orangeColor, Graphics.COLOR_TRANSPARENT);
      }
      if (batteryLevel.equals("6")) {
        dc.setColor(redColor, Graphics.COLOR_TRANSPARENT);
      }
      font = customIconsSmallMaterial;
      if (iconsType == 1) {
        font = customIconsSmall;
      }
      dataWidth = dc.getTextWidthInPixels(batteryLevel, font);
      positionY = positionYLayer4 + batteryPadding;
    }
    dc.drawText(dc.getWidth() / 2 + xBias, positionY, font, batteryLevel,
                Graphics.TEXT_JUSTIFY_CENTER);
  }

 private
  function drawTime(dc) {
    var xBias = 0;
    var positionXHours = dc.getWidth() / 2 - 60;
    var positionXSep = dc.getWidth() / 2;
    var positionXMinutes = dc.getWidth() / 2 + 60;

    var timeFormat = "$1$:$2$";
    var clockTime = System.getClockTime();
    var hours = clockTime.hour;

    if (!millitaryFormat && !System.getDeviceSettings().is24Hour) {
      if (hours > 12) {
        hours = hours - 12;
      }
      // when using the 12 hour clock, midnight is displayed as 12:00 AM (not
      // 0:00 AM)
      if (hours == 0) {
        hours = 12;
      }
    }

    if (leadingZero == true) {
      hours = hours.format("%02d");
    } else if (hours < 10) {
      xBias = 20;
    }
    var hourWidth = dc.getTextWidthInPixels(hours + "", customFont);
    var minutesWidth =
        dc.getTextWidthInPixels(clockTime.min.format("%02d"), customFont);
    var sepWidth = dc.getTextWidthInPixels(":", customFont);
    var timeWidth = (hourWidth + minutesWidth + sepWidth);

    if (noSeparation == true) {
      timeWidth = (hourWidth + minutesWidth);
      // Hours
      dc.setColor(hourColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(dc.getWidth() / 2 - timeWidth / 2 + hourWidth / 2,
                  positionYLayer2, customFont, hours,
                  Graphics.TEXT_JUSTIFY_CENTER);

      // Minutes
      dc.setColor(minutesColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
          dc.getWidth() / 2 - timeWidth / 2 + hourWidth + minutesWidth / 2,
          positionYLayer2, customFont, clockTime.min.format("%02d"),
          Graphics.TEXT_JUSTIFY_CENTER);
    } else {
      // Hours
      dc.setColor(hourColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(dc.getWidth() / 2 - timeWidth / 2 + hourWidth / 2,
                  positionYLayer2, customFont, hours,
                  Graphics.TEXT_JUSTIFY_CENTER);
      // :
      dc.setColor(hourColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(dc.getWidth() / 2 - timeWidth / 2 + hourWidth + sepWidth / 2,
                  positionYLayer2, customFont, ":",
                  Graphics.TEXT_JUSTIFY_CENTER);
      // Minutes
      dc.setColor(minutesColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(dc.getWidth() / 2 - timeWidth / 2 + hourWidth + sepWidth +
                      minutesWidth / 2,
                  positionYLayer2, customFont, clockTime.min.format("%02d"),
                  Graphics.TEXT_JUSTIFY_CENTER);
    }
  }

  // Special Always on display mode for OMALED display such as on Venu
  // The reuqirements is no pixel could be lit more then 3 minutes
  // So we have to move it every minute in a loop to preven pixel burn out
 private
  function drawTimeAOD(dc) {
    var xBias = 0;
    var positionXHours = dc.getWidth() / 2 - 60;
    var positionXSep = dc.getWidth() / 2;
    var positionXMinutes = dc.getWidth() / 2 + 60;

    var timeFormat = "$1$:$2$";
    var clockTime = System.getClockTime();
    var hours = clockTime.hour;

    if (!millitaryFormat && !System.getDeviceSettings().is24Hour) {
      if (hours > 12) {
        hours = hours - 12;
      }
      if (hours == 0) {
        hours = 12;
      }
    }

    hours = hours.format("%02d");

    var hourWidth = dc.getTextWidthInPixels(hours + "", customFontAOD);
    var minutesWidth =
        dc.getTextWidthInPixels(clockTime.min.format("%02d"), customFontAOD);
    var sepWidth = dc.getTextWidthInPixels(":", customFontAOD);
    var timeWidth = (hourWidth + minutesWidth);

    var timeFontHeight = dc.getFontHeight(customFontAOD);
    var y = dc.getHeight() / 2 - timeFontHeight / 2 + layer2Ybias;

    if (aodMinute == 4) {  // 3 minutes for pixel (OLED display restriction)
      aodMinute = 0;
      aodNeedChangePosition = !aodNeedChangePosition;
    } else {
      aodMinute = aodMinute + 1;
    }
    aodX = aodMinute * 30;

    // Hours
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.drawText(dc.getWidth() / 2 + aodX - timeWidth / 4,
                y - timeFontHeight / 2 - 10, customFontAOD, hours,
                Graphics.TEXT_JUSTIFY_CENTER);

    // Minutes
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.drawText(dc.getWidth() / 2 + aodX - timeWidth / 4,
                y + timeFontHeight - timeFontHeight / 2 + 10, customFontAOD,
                clockTime.min.format("%02d"), Graphics.TEXT_JUSTIFY_CENTER);
  }

  // Helper functions
 private
  function getDateString() {
    var today = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var dayOfTheWeek = getDayOfAWeekName(today.day_of_week);
    var monthName = getMonthName(today.month);

    var dateString = dayOfTheWeek + " " + Lang.format("$1$.$2$", [
      today.day,
      today.month,
    ]);

    if (dateFormat == 1) {
      dateString = dayOfTheWeek + " " + Lang.format("$1$.$2$", [

        today.month,
        today.day,
      ]);
    } else if (dateFormat == 2) {
      dateString = dayOfTheWeek + " " + Lang.format("$1$/$2$", [
        today.day,
        today.month,

      ]);
    } else if (dateFormat == 3) {
      dateString = dayOfTheWeek + " " + Lang.format("$1$/$2$", [
        today.month,
        today.day,

      ]);
    } else if (dateFormat == 4) {
      dateString = Lang.format("$1$/$2$/$3$", [
        today.month,
        today.day,
        today.year,

      ]);
    } else if (dateFormat == 5) {
      dateString = Lang.format("$1$/$2$/$3$", [
        today.day,
        today.month,
        today.year,

      ]);
    }

    else if (dateFormat == 6) {
      dateString = Lang.format("$1$", [
        today.day,
      ]) + " " + monthName.substring(0, 3);
    }

    else if (dateFormat == 7) {
      dateString = Lang.format("$1$", [
        today.day,
      ]) + " " + monthName;
    }
    return dateString;
  }

 private
  function getDayOfAWeekName(number) {
    if (lang == 0) {
      return weekdayArr[number - 1];
    }
    if (lang == 2) {
      return weekdayArrIT[number - 1];
    }
    if (lang == 3) {
      return weekdayArrSpanish[number - 1];
    }
    if (lang == 4) {
      return weekdayArrSe[number - 1];
    }
    if (lang == 5) {
      return weekdayArrGerman[number - 1];
    }
    if (lang == 6) {
      return weekdayArrSlovak[number - 1];
    }
    return weekdayArrNor[number - 1];
  }

 private
  function getMonthName(number) {
    if (lang == 0) {
      return monthEn[number - 1];
    }
    if (lang == 2) {
      return monthIT[number - 1];
    }
    if (lang == 3) {
      return monthSp[number - 1];
    }
    if (lang == 4) {
      return monthSE[number - 1];
    }
    if (lang == 5) {
      return monthGE[number - 1];
    }
    if (lang == 6) {
      return monthSL[number - 1];
    }
    return monthNor[number - 1];
  }

 private
  function getBatteryLevel() {
    var battery = Sys.getSystemStats().battery;
    return battery.format("%d") + "%";
  }

 private
  function getBatteryIcon() {
    var battery = Sys.getSystemStats().battery;
    if (battery >= 95) {
      return "0";
    } else if (battery >= 80 && battery < 95) {
      return "1";
    } else if (battery >= 60 && battery < 80) {
      return "2";
    } else if (battery >= 50 && battery < 60) {
      return "3";
    } else if (battery >= 30 && battery < 50) {
      return "4";
    } else if (battery >= 10 && battery < 30) {
      return "5";
    } else if (battery >= 0 && battery < 10) {
      return "6";
    }
    return "7";
  }

 private
  function getHR() {
    var value = "";
    var activityInfo = Activity.getActivityInfo();
    var sample = activityInfo.currentHeartRate;
    if (sample != null) {
      value = sample.format(INTEGER_FORMAT);
    } else if (ActivityMonitor has : getHeartRateHistory) {
      sample =
          ActivityMonitor.getHeartRateHistory(1, /* newestFirst */ true).next();
      if ((sample != null) &&
          (sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE)) {
        value = sample.heartRate.format(INTEGER_FORMAT);
      }
    }
    return value;
  }

  function getWeekNumber() {
    var today = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var weekNumber = iso_week_number(today.year, today.month, today.day);
    return weekNumber;
  }

  function julian_day(year, month, day) {
    var a = (14 - month) / 12;
    var y = (year + 4800 - a);
    var m = (month + 12 * a - 3);
    return day + ((153 * m + 2) / 5) + (365 * y) + (y / 4) - (y / 100) +
           (y / 400) - 32045;
  }

  function is_leap_year(year) {
    if (year % 4 != 0) {
      return false;
    } else if (year % 100 != 0) {
      return true;
    } else if (year % 400 == 0) {
      return true;
    }

    return false;
  }

  function iso_week_number(year, month, day) {
    var first_day_of_year = julian_day(year, 1, 1);
    var given_day_of_year = julian_day(year, month, day);

    var day_of_week = (first_day_of_year + 3) % 7;  // days past thursday
    var week_of_year =
        (given_day_of_year - first_day_of_year + day_of_week + 4) / 7;

    // week is at end of this year or the beginning of next year
    if (week_of_year == 53) {
      if (day_of_week == 6) {
        return week_of_year;
      } else if (day_of_week == 5 && is_leap_year(year)) {
        return week_of_year;
      } else {
        return 1;
      }
    }

    // week is in previous year, try again under that year
    else if (week_of_year == 0) {
      first_day_of_year = julian_day(year - 1, 1, 1);

      day_of_week = (first_day_of_year + 3) % 7;

      return (given_day_of_year - first_day_of_year + day_of_week + 4) / 7;
    }

    // any old week of the year
    else {
      return week_of_year;
    }
  }
}