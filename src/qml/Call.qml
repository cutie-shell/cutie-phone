import Cutie 1.0
import QtQuick 2.14

CutiePage {
	id: root
	width: mainWindow.width
	height: mainWindow.height
	property var lineId: ""
	property var call: null

	Component.onDestruction: {
		root.call.modem.audioMode = 0;
		root.call.hangup();
	}

	CutiePageHeader {
		id: header
		title: root.lineId
		anchors.top: parent.top
	}

	CutieButton {
		id: answer
		visible: root.call.data["State"] === "incoming"
		anchors.bottom: hangup.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: 20
		text: "Answer"
		onClicked: {
			root.call.modem.audioMode = 1;
			root.call.answer();
		}
	}

	CutieButton {
		id: hangup
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: 20
		text: "Hangup"
		color: "red"
		onClicked: {
			root.call.hangup();
			root.call.modem.audioMode = 0;
		}
	}

	Connections {
		target: root.call
		function onDisconnected(reason) {
			if (reason == "local") {
				toastHandler.show("Call ended successfully", 2000);
			}
			else if (reason == "remote") {
				toastHandler.show("Call ended by the remote party", 2000);
			}
			else {
				toastHandler.show("Call ended by the network", 2000);
			}

			pageStack.pop(root);
		}
	}
}
