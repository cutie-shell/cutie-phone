import Cutie
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

CutieWindow {
	id: mainWindow
	width: 400
	height: 800
	title: qsTr("Phone")

	CutieStore {
		id: logStore
		appName: "cutie-phone"
		storeName: "callLog"
	}

	initialPage: CutiePage {
		width: mainWindow.width
		height: mainWindow.height
		ColumnLayout{
			spacing: 10
			anchors.fill: parent

			CutiePageHeader {
				id: header
				title: mainWindow.title
			}

			CutieListView {
				id: lView
				Layout.fillWidth: true
				Layout.fillHeight: true
				model: logStore.data.entries
				clip: true
				Component.onCompleted: positionViewAtIndex(count - 1, ListView.End)
				onCountChanged: positionViewAtIndex(count - 1, ListView.End)

				delegate: CutieListItem {
					width: parent ? parent.width : 0
					id: litem
					text: modelData.lineId
					subText: qsTr("%1 - %2").arg(modelData.type).arg((new Date(modelData.time)).toString())
					icon.source: "qrc:/icons/" + modelData.type + ".svg"
					iconOverlay: false

					onClicked: {
						recipentText.text = modelData.lineId
					}

					menu: CutieMenu {
						CutieMenuItem {
							text: qsTr("Delete")
							onTriggered: {
								let data = logStore.data;
								data.entries.splice(index, 1);
								logStore.data = data;
							}
						}
					}
				}
			}

			CutieTextField {
				id: recipentText
				text: ""
				Layout.fillWidth: true
				Layout.preferredHeight: 60
				font.bold: true
				font.pixelSize: 38
				inputMethodHints: Qt.ImhDialableCharactersOnly

				horizontalAlignment: TextInput.AlignHCenter
				onAccepted: {
					if(recipentText.text != ""){
						CutieModemSettings.modems[0].dial(recipentText.text);
						CutieModemSettings.modems[0].audioMode = 1;
					}
				}

				Button {
					id: btnCall
					palette.buttonText: Atmosphere.textColor
					width: 50
					height: 50
					anchors.right: parent.right
					anchors.bottom: parent.bottom
					anchors.margins: 10
					visible: btnDialPad.visible && recipentText.text != ""

					icon.name: "call-start-symbolic"
					icon.height: height * 0.7
					icon.width: height * 0.7
					icon.color: "white"

					background: Rectangle {
						anchors.fill: parent
						radius: 90
						color: "green"
						border.color: Atmosphere.secondaryColor
						border.width: 1
					}

					onClicked: {
						if(recipentText.text != ""){
							CutieModemSettings.modems[0].dial(recipentText.text);
							CutieModemSettings.modems[0].audioMode = 1;
						}
					}
				}
			}

			Button {
				id: btnDialPad
				palette.buttonText: Atmosphere.textColor
				Layout.preferredWidth: 50
				Layout.preferredHeight: 50
				Layout.alignment: Qt.AlignCenter
				Layout.bottomMargin: 20
				visible: mainWindow.height > Screen.height * 0.8

				icon.name: "input-dialpad-symbolic"
				icon.height: height * 0.75
				icon.width: height * 0.75
				icon.color: Atmosphere.textColor

				background: Rectangle {
					anchors.fill: parent
					radius: 5
					color: btnDialPad.pressed ? Atmosphere.accentColor : Atmosphere.primaryColor
					border.color: Atmosphere.secondaryColor
					border.width: 1
				}

				onClicked: {
					recipentText.forceActiveFocus();
				}
			}
		}	
	}
}
