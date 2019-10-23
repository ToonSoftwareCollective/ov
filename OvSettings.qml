import QtQuick 1.1
import qb.components 1.0

Screen {
	id: ovSettingsScreen
	screenTitleIconUrl: "./drawables/ovIcon.png"
	screenTitle: "Ov / Instellingen"
	hasBackButton: false
	hasHomeButton: false
	hasCancelButton: true

	anchors {
		top: parent.top
		topMargin: 5
		left: parent.left
		leftMargin: 32
	}

	onShown: {
		if (app.settings.stationFilter) updateovHalteLabel(app.settings.stationFilter);
		addCustomTopRightButton("Kies halte/station");
	}

	function updateovHalteLabel(text) {
		ovHalteLabel.inputText = text;
		var temp = app.settings; 
		temp.stationFilter = text;
		app.settings = temp;
		app.saveSettings();
		app.searchHaltes(text);
	}

	
	EditTextLabel {
		id: ovHalteLabel
		width: isNxt ? 800 : 500
		height: 35
		leftText: "Zoek Halte:"
		leftTextAvailableWidth: isNxt ? 250 : 200
		anchors {
			left: parent.left
			top: parent.top                       
			topMargin: 30
		}

		onClicked: {
			qkeyboard.open("Station / Halte", ovHalteLabel.inputText, updateovHalteLabel);
		}
	}

	Text {
		id: ovText
		text: "Selekteer een van de haltes:"
		anchors {
			left: ovHalteLabel.left
			top: ovHalteLabel.bottom                       
			topMargin: isNxt ? 15 : 12
		}
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 25 : 20
		}

	}

	Grid {
		spacing:10
		columns: 2
		rows: 16
		anchors {
			top: ovText.bottom
			topMargin: isNxt ? 25 : 20
			left: ovText.left
		}

		Repeater {
			id: halteRepeater
			model: app.haltes
		   	OvSettingsDelegate { 
				visible: ((app.haltes[index]['stopType'] == "Bushalte") || (app.haltes[index]['stopType'] == "Metrostation") || (app.haltes[index]['stopType'] == "Bus-/tramhalte") || (app.haltes[index]['stopType'] == "Tramhalte")  || (app.haltes[index]['stationType'] == "Station"))  ? true : false
				halteId: app.haltes[index]['id'];
				stopType: (!app.haltes[index]['stopType']) ? "" : app.haltes[index]['stopType']
				stationType: (!app.haltes[index]['stationType']) ? "" : app.haltes[index]['stationType']
				place: app.haltes[index]['place']['name'];
				name: app.haltes[index]['name'];
			} 
		}
	}
}
