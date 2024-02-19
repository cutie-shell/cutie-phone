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
		anchors.top: header.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: 20
		onAccepted: {
			CutieModemSettings.modems[0].dial(recipentText.text);
			CutieModemSettings.modems[0].audioMode = 1;
		}
		inputMethodHints: Qt.ImhDialableCharactersOnly
	}
}