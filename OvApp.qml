import QtQuick 1.1
import qb.components 1.0
import qb.base 1.0

App {
	id: ovApp
	
	property url trayUrl : "OvTray.qml"
	property url tileUrl : "OvTile.qml"
	
	property url thumbnailIcon: "./drawables/ovIcon.png"
	property url tileIcon: "./drawables/ovTile.png"
	
	property url ovScreenUrl : "OvScreen.qml"
	property url ovSettingsUrl : "OvSettings.qml"
	property OvSettings ovSettings
	property OvScreen ovScreen

	property bool firstLoad: true
	property bool settingsLoaded: false
	property bool runningFromTile: false
	property variant departures : []
	property variant haltes : []

		// props for Tile
	property string depLine
	property string depTime
	property string depRealtimeState
	property string depRealtime
	property string depStopType
	property string depStationType
	property string depPlatform
	property string depDestination
	property string depTrainType

	property variant settings: { 
		"ovHalte" : "",
		"stopType" : "",
		"stationType" : "",
		"name" : "",
		"filter" : "",
		"stationFilter" : "",
	}

	function init() {
		registry.registerWidget("tile", tileUrl, this, null, {thumbLabel: qsTr("OV"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, thumbIconVAlignment: "center"});
		registry.registerWidget("screen", ovScreenUrl, this, "ovScreen");
		registry.registerWidget("screen", ovSettingsUrl, this, "ovSettings");
		registry.registerWidget("systrayIcon", trayUrl, this, "ovTray");
	}


	Component.onCompleted: {
		loadSettings();
	}

	function loadSettings()  {
		var settingsFile = new XMLHttpRequest();
		settingsFile.onreadystatechange = function(){
			if (settingsFile.readyState == XMLHttpRequest.DONE) {
				if (settingsFile.responseText.length > 0)  {
					settingsLoaded=true
					
					var temp = JSON.parse(settingsFile.responseText);
					for (var setting in settings) {
						if (!temp[setting])  { temp[setting] = settings[setting]; } // use default if no saved setting exists
					}
					settings = temp;
					depStopType = settings.stopType;
					depStationType = settings.stationType;
					if (settings.ovHalte !== "") getOV();
					ovTimer.start();				
				}
			}
		}
		settingsFile.open("GET", "file:///HCBv2/qml/apps/ov/ov.settings", true);
		settingsFile.send();
	}
	
	function saveSettings() {
		var saveFile = new XMLHttpRequest();
		saveFile.open("PUT", "file:///HCBv2/qml/apps/ov/ov.settings");
		saveFile.send(JSON.stringify(settings));
		depStopType = settings.stopType;
		depStationType = settings.stationType;
	}

	function searchHaltes(searchStr) {

		var xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				var res = JSON.parse(xmlhttp.responseText);
				haltes = res["locations"];
			}
		}
		xmlhttp.open("GET", "http://api.9292.nl/0.1/locations?lang=nl-NL&q=" + searchStr, true);
		xmlhttp.send();

	}

	function dutchTranslate(text) {
                switch (text) {
                        case "early": return "eerder";
                        case "late": return "later";
                        case "ontime": return "op tijd";
                        default: break;
              }
		return "?";
	}

	function getOV(){

	
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				var res = JSON.parse(xmlhttp.responseText);
				departures = res["tabs"][0]["departures"];

					// fill tile

					for (var i = 0; i < departures.length; i++) {
						if (departures[i]['destinationName'].indexOf(settings.filter) > -1) {
							depTime = departures[i]['time'];
							depDestination = departures[i]['destinationName'];
							depLine = "";
							if (departures[i]['service']) depLine = departures[i]['service'];
							depPlatform = "";
							if (departures[i]['platform']) depPlatform = departures[i]['platform'];
							depTrainType = "";
							if (departures[i]['mode']['name']) depTrainType= departures[i]['mode']['name'];
							depRealtimeState = "";
							if (departures[i]['realtimeState']) depRealtimeState= dutchTranslate(departures[i]['realtimeState']);
							depRealtime = "";
							if (departures[i]['realtimeText']) depRealtime= departures[i]['realtimeText'];
							break;
						}	
					}
			}
		}
		xmlhttp.open("GET", "http://api.9292.nl/0.1/locations/" + settings.ovHalte + "/departure-times?lang=nl-NL", true);
		xmlhttp.send();
	}
	

	Timer  {
        	id: ovTimer
	       	interval: 120000 // retrieve refreshed info every 2 minutes
       	 	running: false
        	repeat: true
        	onTriggered: {
			if (settings.ovHalte !== "") getOV();
		}
    	}
}
