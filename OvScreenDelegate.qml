import QtQuick 1.1
import BasicUIControls 1.0

Item {
	id: textItem
	width: isNxt ? 900 : 700
	height: isNxt ? 25 : 19
	
	property string depTime
	property string depDestination
	property string depLine
	property string depRealtime
	property string depRealtimeState
	property string depPlatform
	property string depTrainType
	property string depName
	property string showTile
	property color colorDark: "#565656"

	function colorTime() {
/*		if ((app.initTile) && (showTile)) {
			app.depLine = depLine;
			app.depTime = depTime;
			app.depRealtime = depRealtime;
			app.depRealtimeState = depRealtimeState;
			app.depPlatform = depPlatform;
			app.depDestination = depDestination;
			app.depTrainType = depTrainType;
			app.initTile = false;
		}
*/
		if (depRealtimeState == "op tijd") {
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
			color: colorDark
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
			text: depTime
		}

		Text {
			id: text1Time
			width: isNxt ? 100 : 80
			color: colorTime()
			anchors {
			   top: parent.top
			   topMargin: 5
			   left: text1Title.right
			   leftMargin: isNxt ? 10 : 8
			}
			font {
				family: qfont.semiBold.name
				pixelSize: isNxt ? 20 : 16
			}
			text: depRealtime
		}

		Text {
			id: state1Time
			width: isNxt ? 100 : 80
			color: colorTime()
			anchors {
			   top: parent.top
			   topMargin: 5
			   left: text1Time.right
			   leftMargin: isNxt ? 10 : 8
			}
			font {
				family: qfont.semiBold.name
				pixelSize: isNxt ? 20 : 16
			}
			text: depRealtimeState
		}

		Text {
			id: text1Data
			width: isNxt ? 50 : 40
			color: colorDark
			anchors {
			   top: parent.top
			   topMargin: 5
			   left: state1Time.right
			   leftMargin: isNxt ? 10 : 8
			}
			font {
				family: qfont.semiBold.name
				pixelSize: isNxt ? 20 : 16
			}
			text: depLine + " " + depPlatform
		}

		Text {
			id: text1Dest
			width: isNxt ? 400 : 320
			color: colorDark
			anchors {
			   top: parent.top
			   topMargin: 5
			   left: text1Data.right
			   leftMargin: isNxt ? 27 : 22
			}
			font {
				family: qfont.semiBold.name
				pixelSize: isNxt ? 20 : 16
			}
			text: depDestination
		}

		Text {
			id: text1Type
			width: isNxt ? 75 : 60
			color: colorDark
			anchors {
			   top: parent.top
			   topMargin: 5
			   left: text1Dest.right
			   leftMargin: isNxt ? 10 : 8
			}
			font {
				family: qfont.semiBold.name
				pixelSize: isNxt ? 20 : 16
			}
			text: depTrainType
		}
	}
}
