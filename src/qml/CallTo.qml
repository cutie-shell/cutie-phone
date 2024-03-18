import Cutie
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

CutiePage {
	id: root

	property string predial: ""

	Component.onCompleted: {
		recipentText.forceActiveFocus();
	}

	CutiePageHeader {
		id: header
		title: qsTr("Dialpad")
	}
	
	CutieTextField {
		id: recipentText
		text: predial
		anchors.bottom: connectbutton.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: 20
		onAccepted: {
			CutieModemSettings.modems[0].dial(recipentText.text);
			CutieModemSettings.modems[0].audioMode = 1;
		}
		inputMethodHints: Qt.ImhDialableCharactersOnly
	}

	CutieButton {
		id: connectbutton
		icon.name: "call-start-symbolic"
		icon.color: Atmosphere.textColor
		icon.width: 25
		icon.height: 25
		color: "green"
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: 5
		height: 50
		onClicked: {
			recipentText.onAccepted();
		}
	}
}