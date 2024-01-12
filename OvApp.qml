import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0
import FileIO 1.0

App {
	id: ovApp
	
	property url trayUrl : "OvTray.qml"
	property url tileUrl : "OvTile.qml"
	
	property url thumbnailIcon: "qrc:/tsc/ovIcon.png"
	property url tileIcon: "qrc:/tsc/ovTile.png"
	
	property url ovScreenUrl : "OvScreen.qml"
	property url ovSettingsUrl : "OvSettings.qml"
	property OvSettings ovSettings
	property OvScreen ovScreen

	property bool firstLoad: true
	property bool settingsLoaded: false
	property bool runningFromTile: false
	property bool initTile: true

	property variant departures : []
	property variant haltes : []

		// props for Tile
	property string depLijn
	property string depTijd
	property string depVervoeder
	property string depRichting
	property string depStopType
	property string depMode
	property string haltesString : ""
	property string departuresString : ""

	// settings
	property string ovHalte : ""
	property string stationFilter : ""
	property string filter : ""
	property string screenTitle : ""
	property variant settings : {
		"ovHalte" : "",
		"filter" : "",
		"screenTitle" : "",
		"stationFilter" : ""
	}

	FileIO {
		id: ovSettingsFile
		source: "file:///mnt/data/tsc/ov.userSettings.json"
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

		//read user settings

		var settingsString = ovSettingsFile.read();
		if (settingsString.length > 2)  {
				
			var temp = JSON.parse(settingsString);
			if (temp["ovHalte"]) ovHalte = temp["ovHalte"];
			if (temp["stationFilter"]) stationFilter= temp["stationFilter"];
			if (temp["screenTitle"]) screenTitle = temp["screenTitle"];
			if (temp["filter"]) filter = temp["filter"];
			if (ovHalte !== "") getOV();
		}
		ovTimer.start();
	}
	
	function saveSettings() {

		// save user settings
 		var tmpUserSettingsJson = {
			"ovHalte": ovHalte,
			"stationFilter": stationFilter,
			"filter": filter,
			"screenTitle": screenTitle,
		}

		var saveFile = new XMLHttpRequest();
		saveFile.open("PUT", "file:///mnt/data/tsc/ov.userSettings.json");
		saveFile.send(JSON.stringify(tmpUserSettingsJson ));
	}

	function decodeHaltes(htmlText) {

		var i = 0;
		var j = 0;
		var k = 0;
		var l = 0;
		var haltecounter = 0;
		var href = "";
		var stoparea = "";
		var stoptype = "";
		var naam = "";
		var komma = "";

		haltesString = '{"Haltes":[';

		i = htmlText.indexOf("<a href");
		if ( i > 0 ) {
			while (i > 0) {
				haltecounter = haltecounter + 1;
				j = htmlText.indexOf('"', i+10);
				href = htmlText.substring(i+9,j);

				k = htmlText.indexOf('tt-main-stoparea-title', i);
				l = htmlText.indexOf('<', k);
				stoparea = htmlText.substring(k+24,l);

				k = htmlText.indexOf('<b>', l);
				l = htmlText.indexOf('</b>', k);
				stoptype = htmlText.substring(k+3,l);

				k = htmlText.indexOf('</b>', k);
				l = htmlText.indexOf("</div>", k);
				naam = htmlText.substring(k+5,l-17);

				if (haltecounter > 1) komma = ",";

				haltesString = haltesString + komma + '{"href":"' + href + '","stoparea":"' + stoparea + '","stoptype":"' + stoptype + '","naam":"' + naam + '"}' 

				i = htmlText.indexOf("<a href", i + 10);
			}
		}
		haltesString = haltesString + ']}';
		haltes = JSON.parse(haltesString);
	}

	function searchHaltes(searchStr) {

		console.log("OvJoop: start zoekhalte:" + searchStr);
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				decodeHaltes(xmlhttp.responseText);
			}
		}
		xmlhttp.open("GET", "https://drgl.nl/searchengine?query=" + searchStr, true);
		xmlhttp.send();

	}

	function getMode(text) {
                switch (text) {
                        case "Bus": return "Bus";
                        case "Met": return "Metro";
                        case "Tra": return "Tram";
                        case "Vee": return "Boot";
                        default: break;
              }
		return "?";
	}

	function getOV(){

		var xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {

				var htmlText = xmlhttp.responseText;
//				console.log("OV2 dep:" + htmlText);
				var i = 0;
				var j = 0;
				var k = 0;
				var l = 0;
				var vertrekcounter = 0;
				var tijd = "";
				var lijn = "";
				var richting = "";
				var vervoerder = "";
				var komma = "";
				initTile = true;

				departuresString = '{"Vertrek":[';

				i = htmlText.indexOf('href="/journey/');
				i = htmlText.indexOf('<div class="ott-dep',i);
				i = htmlText.indexOf('>',i);
				if ( i > 0 ) {
					while (i > 0) {
						vertrekcounter = vertrekcounter + 1;
						j = htmlText.indexOf('<', i);
						tijd = htmlText.substring(i+1,j);
		
						k = htmlText.indexOf('<div class="ott-lin', i);
						k = htmlText.indexOf('>', k);
						l = htmlText.indexOf('<', k);
						lijn = htmlText.substring(k+1,l);

						k = htmlText.indexOf('<div class="ott-des', l);
						k = htmlText.indexOf('>', k);
						l = htmlText.indexOf('<', k);
						richting = htmlText.substring(k+1,l);
						richting = richting.replace(/&#x27;/g, "'")

						k = htmlText.indexOf('<div class="ott-pro', l);
						k = htmlText.indexOf('>', k);
						l = htmlText.indexOf('<', k);
						vervoerder = htmlText.substring(k+1,l);
						vervoerder = vervoerder.replace(/&bull;/g, "")

						if (vertrekcounter > 1) komma = ",";

						departuresString = departuresString + komma + '{"tijd":"' + tijd + '","lijn":"' + lijn + '","richting":"' + richting + '","vervoerder":"' + vervoerder + '"}' 

						i = htmlText.indexOf('href="/journey/', l);
						if (i > 0 ) {
							i = htmlText.indexOf('<div class="ott',i);
							i = htmlText.indexOf('>',i);
						}
					}
				}
				departuresString = departuresString + ']}';
				console.log("OV2 depstr:" + departuresString );
				departures = JSON.parse(departuresString);
				console.log("OV2 dep:" + departures["Vertrek"].length);
			}
		}
		xmlhttp.open("GET", "https://drgl.nl" + ovHalte, true);
		xmlhttp.send();
		console.log("OV2: https://drgl.nl" + ovHalte);

	}
	

	Timer  {
        	id: ovTimer
	       	interval: 120000 // retrieve refreshed info every 2 minutes
       	 	running: false
        	repeat: true
        	onTriggered: {
			if (ovHalte !== "") getOV();
		}
    	}
}
