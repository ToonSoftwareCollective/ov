import QtQuick 2.1

import qb.components 1.0
import qb.base 1.0

SystrayIcon {
	id: ovSystrayIcon
	property string objectName: "ovSystrayIcon"

	visible: true
	posIndex: 8000

	onClicked: {
		app.getOV();
		stage.openFullscreen(app.ovScreenUrl);
	}

	Image {
		id: imgOv
		anchors.centerIn: parent
		source: "qrc:/tsc/ovIcon.png"
	}

}
