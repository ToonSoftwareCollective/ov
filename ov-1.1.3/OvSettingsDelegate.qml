import QtQuick 2.1
import BasicUIControls 1.0
import qb.components 1.0

Item {
	id: textItem
	width: isNxt ? 475 : 380
	property string halteId
	property string stopType
	property string stationType
	property string name
	property string place

	height: isNxt ? 35 : 28

	StandardButton {
		id: halteButton

		width: isNxt ? 475 : 360
		height: isNxt ? 30 : 24
		radius: 5
		text: stopType + stationType + " " + name + " (" + place + ")"
		fontPixelSize: isNxt ? 18 : 15
		color: colors.background

		anchors {
			top: parent.top
			topMargin: isNxt ? 5 : 4
			left: parent.left
			leftMargin: isNxt ? 5 : 4
		}

		onClicked: {
			app.settings.ovHalte = halteId;
			var temp = app.settings; 
			temp.ovHalte = halteId;
			temp.stopType = stopType;
			temp.stationType = stationType;
			temp.name = name;
			temp.filter = "";
			app.settings = temp;
			app.getOV();
			app.saveSettings();
			hide();
		}
	}
}
