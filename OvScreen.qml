import QtQuick 2.1
import qb.components 1.0

Screen {
	id: ovScreen
	screenTitle: app.screenTitle
	property color colorDark: "#565656"
	
	hasBackButton: false

	onShown: {
		addCustomTopRightButton("Kies halte/station");
		updateFilter(app.filter);
	}

	onCustomButtonClicked: {
		app.ovSettings.show();
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
		   left: text1Title.left
		   leftMargin: isNxt ? 160 : 120
		}
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 20 : 16
		}
		text: "Lijn"
	}

	function updateFilter(text) {
		destinationFilter.inputText = text; 	//update screen field
		app.filter = text;
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
			model: app.departures["Vertrek"]
		   	OvScreenDelegate { 
				visible: ((index <= 11) && (app.departures["Vertrek"][index]['richting'].indexOf(app.filter) > -1)) ? true : false
				showTile: (app.departures["Vertrek"][index]['richting'].indexOf(app.filter) > -1) ? true : false
				depTijd: app.departures["Vertrek"][index]['tijd']
				depRichting: app.departures["Vertrek"][index]['richting']
				depVervoerder: app.departures["Vertrek"][index]['vervoerder']
				depLijn: app.departures["Vertrek"][index]['lijn']
				depMode: app.getMode(app.screenTitle.substring(0,3))
			} 
		}
	}
}
