import QtQuick 2.1
import qb.components 1.0

Tile {
	id: ovTile

	onClicked: {
		app.ovScreen.show();
	}
	

	Text {
		id: tileLine
		text: app.depMode + " " + app.depLijn
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 30 : 24
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.waTileTextColor : colors.waTileTextColor
	}
	
	Text {
		id: tileDest
		text: app.depRichting.substring(0,25)
		anchors {
			top: tileLine.bottom
			topMargin: isNxt ? 15 : 12
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 20 : 16
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.waTileTextColor : colors.waTileTextColor
	}	

	Text {
		id: tileTime
		text: app.depTijd
		anchors {
			top: tileDest.bottom
			topMargin: isNxt ? 15 : 12
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.waTileTextColor : colors.waTileTextColor
	}
	
	Text {
		id: tileStop
		text: app.screenTitle
		anchors {
			top: tileTime.bottom
			topMargin: isNxt ? 25 : 20
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 15 : 12
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.waTileTextColor : colors.waTileTextColor
	}
}
