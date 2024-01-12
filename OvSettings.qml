import QtQuick 2.1
import qb.components 1.0

Screen {
	id: ovSettingsScreen
	screenTitleIconUrl: "qrc:/tsc/ovIcon.png"
	screenTitle: "Ov / Instellingen"

	anchors {
		top: parent.top
		topMargin: 5
		left: parent.left
		leftMargin: 32
	}

	onShown: {
		updateovHalteLabel(app.stationFilter);
	}

	function updateovHalteLabel(text) {
		ovHalteLabel.inputText = text;
		app.stationFilter = text;
		app.saveSettings();
		app.searchHaltes(text);
	}

	
	EditTextLabel4421 {
		id: ovHalteLabel
		width: isNxt ? 800 : 500
		height: isNxt ? 45 : 36
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
		rows: 8
		anchors {
			top: ovText.bottom
			topMargin: isNxt ? 25 : 20
			left: ovText.left
		}

		Repeater {
			id: halteRepeater
			model: app.haltes["Haltes"]
		   	OvSettingsDelegate { 
//				visible: (app.haltes["Haltes"][index]['stoptype'] == "Treinstation")  ? false : true
				href: app.haltes["Haltes"][index]['href']
				stoptype: app.haltes["Haltes"][index]['stoptype']
				stoparea: app.haltes["Haltes"][index]['stoparea']
				name: app.haltes["Haltes"][index]['naam']
			} 
		}
	}
}
