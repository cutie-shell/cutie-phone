import Cutie
import QtQuick
import QtMultimedia

CutiePage {
	id: root
	width: mainWindow.width
	height: mainWindow.height
	property var lineId: ""
	property var call: null
	property bool wasIncoming: false
	property bool answered: false

	Component.onDestruction: {
		root.call.modem.audioMode = 0;
		root.call.hangup();
	}

	Component.onCompleted: {
		root.wasIncoming = root.call.data["State"] === "incoming";
		if (root.wasIncoming) {
			callSound.play();
		}
	}

	SoundEffect {
        id: callSound
        source: "qrc:/icons/ringtone.wav"
        loops: SoundEffect.Infinite
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
			callSound.stop();
			root.call.modem.audioMode = 1;
			root.call.answer();
			root.answered = true;
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
			callSound.stop();
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

			let data = logStore.data;
			let logEntries = data.entries;
			if (!logEntries) logEntries = [];
			logEntries.push({
				lineId: root.lineId,
				time:  Date.now(),
				type: (root.wasIncoming 
				? (root.answered ? "Incoming" : "Missed")
				: "Outgoing")
			});
			data.entries = logEntries;
			logStore.data = data;

			pageStack.pop(root);
		}
	}
}
