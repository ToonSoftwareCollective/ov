import QtQuick 2.1
import qb.components 1.0

Screen {
	id: ovScreen
	screenTitleIconUrl: "qrc:/tsc/ovIcon.png"
	screenTitle: app.settings.stopType + app.settings.stationType + " "+ app.settings.name
	property color colorDark: "#565656"
	
	hasBackButton: false

	onShown: {
		destinationFilter.inputText = app.settings.filter;
		addCustomTopRightButton("Kies halte/station");
	}

	onCustomButtonClicked: {
		app.ovSettings.show();
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

	Text {
		id: text1Title
		width:isNxt ? 60 : 48
		color: colorDark
		anchors {
		   bottom: ovBG.top
		   bottomMargin: isNxt ? 10 : 8
		   left: ovBG.left
		   leftMargin: isNxt ? 10 : 8
		}
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 20 : 16
		}
		text: "Vertrektijd"
	}
	

	Text {
		id: text1Data
		width: isNxt ? 50 : 40
		color: colorDark
		anchors {
		   top: text1Title.top
		   left: text1Title.right
		   leftMargin: isNxt ? 228 : 180
		}
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 20 : 16
		}
		text: (app.settings.stationType == "Station") ? "Spoor" : "Lijn"
	}

	function updateFilter(text) {
		destinationFilter.inputText = text; 	//update screen field
		var temp = app.settings; 		// save settings (filter)
		temp.filter = text;
		app.settings = temp;
		app.saveSettings();
		app.getOV();				//reload data
	}
	
	EditTextLabel4421 {
		id: destinationFilter
		width: isNxt ? 585 : 458
		height: isNxt ? 35 : 32
		leftText: "Bestemming                             filter:"
		leftTextAvailableWidth: isNxt ? 350 : 280
		anchors {
			right: ovBG.right
			top: text1Data.top  
			topMargin: isNxt ? -4 : -5                     
		}
		labelFontFamily: qfont.semiBold.name
		labelFontSize: isNxt ? 20 : 16

		onClicked: {
			qkeyboard.open("Filter bestemming", destinationFilter.inputText, updateFilter);
		}
	}

	Rectangle {
		id: ovBG
		width: isNxt ? 950 : 750
		height: isNxt ? 450 : 360
		radius: 3
		color: "#f0f0f0"
		anchors {
			top: parent.top
			topMargin: isNxt ? 55 : 60
			left: parent.left
			leftMargin: isNxt ? 32 : 24
		}
	}
	
	Grid {
		spacing:10
		columns: 1
		rows:15
		anchors {
			top: parent.top
			topMargin: 65
			left: parent.left
			leftMargin: 32
		}

		Repeater {
			id: departuresRepeater
			model: app.departures
		   	OvScreenDelegate { 
				visible: ((index <= 11) && (app.departures[index]['destinationName'].indexOf(app.settings.filter) > -1)) ? true : false
				showTile: (app.departures[index]['destinationName'].indexOf(app.settings.filter) > -1) ? true : false
				depTime: app.departures[index]['time']
				depDestination: app.departures[index]['destinationName']
				depLine: app.departures[index]['service']
				depPlatform: app.departures[index]['platform']
				depTrainType: app.departures[index]['mode']['name']
				depRealtimeState: dutchTranslate(app.departures[index]['realtimeState']) 
				depRealtime: app.departures[index]['realtimeText']
			} 
		}
	}
}
