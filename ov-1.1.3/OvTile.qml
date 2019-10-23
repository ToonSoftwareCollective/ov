import QtQuick 2.1
import qb.components 1.0

Tile {
	id: ovTile

	onClicked: {
		app.ovScreen.show();
	}
	
	function tileTitle() {
		if (app.depStationType == "Station") {
			return "Trein Spoor " + app.depPlatform
		} else {
			if (app.depStopType == "Bushalte") {
			 	return "Bus " + app.depLine
			} else {
				return app.depTrainType + " " + app.depLine
			}
		}
	}

	Text {
		id: tileLine
		text: tileTitle()
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 30 : 24
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: colors.waTileTextColor
	}
	
	Text {
		id: tileDest
		text: app.depDestination.substring(0,25)
		anchors {
			top: tileLine.bottom
			topMargin: isNxt ? 15 : 12
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 20 : 16
		}
		color: colors.waTileTextColor
	}	

	Text {
		id: tileTime
		text: app.depTime
		anchors {
			top: tileDest.bottom
			topMargin: isNxt ? 15 : 12
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: colors.waTileTextColor
	}
	
	Text {
		id: tileRealTime
		text: app.depRealtime + " " + app.depRealtimeState
		anchors {
			top: tileTime.bottom
			topMargin: isNxt ? 15 : 12
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: colors.waTileTextColor
	}
}
