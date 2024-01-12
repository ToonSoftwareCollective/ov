import QtQuick 2.1
import BasicUIControls 1.0
import qb.components 1.0

Item {
	id: textItem
	width: isNxt ? 475 : 380
	property string href
	property string stoptype
	property string stoparea
	property string name

	height: isNxt ? 70 : 54

	StandardButton {
		id: halteButton

		width: isNxt ? 475 : 360
		height: isNxt ? 60 : 48
		radius: 5
		text: stoptype + " " + stoparea + "\n(" + name + ")"
		fontPixelSize: isNxt ? 20 : 15
		color: colors.background

		onClicked: {
			app.ovHalte = href;
			app.screenTitle = stoptype + " " + stoparea;
			app.departures = JSON.parse('{"Vertrek":[]}');
			app.getOV();
			app.saveSettings();
			hide();
		}
	}
}
