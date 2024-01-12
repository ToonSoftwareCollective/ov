import QtQuick 2.1
import BasicUIControls 1.0

Item {
	id: textItem
	width: isNxt ? 900 : 700
	height: isNxt ? 25 : 19
	
	property string depTijd
	property string depRichting
	property string depLijn
	property string depMode
	property string depVervoerder
	property string showTile
	property color colorDark: "#565656"

	function colorTime() {
		if ((app.initTile) && (showTile) && (depRichting.indexOf(app.filter) > -1)) {
			app.depLijn = depLijn;
			app.depTijd = depTijd;
			app.depRichting = depRichting;
			app.depMode = depMode;
			app.initTile = false;
		}

		if (depTijd.indexOf("+") < 0) {
			return "#00FF00"
		} else {
			return "#FF0000"
		}
			
	}
	
	Item {
		anchors.fill: parent
		
		Text {
			id: text1Title
			width:isNxt ? 60 : 48
			color: colorTime()
			anchors {
			   top: parent.top
			   topMargin: 5
			   left: parent.left
			   leftMargin: isNxt ? 10 : 8
			}
			font {
				family: qfont.semiBold.name
				pixelSize: isNxt ? 20 : 16
			}
			text: depTijd
		}


		Text {
			id: text1Data
			width: isNxt ? 50 : 40
			color: colorDark
			anchors {
			   top: parent.top
			   topMargin: 5
			   left: text1Title.left
			   leftMargin: isNxt ? 160 : 120
			}
			font {
				family: qfont.semiBold.name
				pixelSize: isNxt ? 20 : 16
			}
			text: depLijn
		}

		Text {
			id: text1Dest
			width: isNxt ? 400 : 320
			color: colorDark
			anchors {
			   top: parent.top
			   topMargin: 5
			   left: text1Title.left
			   leftMargin: isNxt ? 365 : 265
			}
			font {
				family: qfont.semiBold.name
				pixelSize: isNxt ? 20 : 16
			}
			text: depRichting
		}

		Text {
			id: text1Type
			width: isNxt ? 125 : 100
			color: colorDark
			anchors {
			   top: parent.top
			   topMargin: 5
			   right: parent.right
			   rightMargin: isNxt ? 5 : 4
			}
			font {
				family: qfont.semiBold.name
				pixelSize: isNxt ? 20 : 16
			}
			text: depVervoerder
		}
	}
}
