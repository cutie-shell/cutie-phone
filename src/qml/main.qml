import Cutie
import QtQuick

CutieWindow {
	id: mainWindow
	width: 400
	height: 800
	title: qsTr("Phone")

	function predial(number) {
		pageStack.push("qrc:/CallTo.qml", {
			predial: number
		});
	}

	CutieStore {
		id: logStore
		appName: "cutie-phone"
		storeName: "callLog"
	}

	initialPage: CutiePage {
		width: mainWindow.width
		height: mainWindow.height
		CutieListView {
			id: lView
			anchors.fill: parent
			model: logStore.data.entries

			header: CutiePageHeader {
				id: header
				title: mainWindow.title
			}

			menu: CutieMenu {
				CutieMenuItem {
					text: qsTr("Show Numberpad")
					onTriggered: {
						pageStack.push("qrc:/CallTo.qml", {})
					}
				}
			}

			delegate: CutieListItem {
				width: parent ? parent.width : 0
				id: litem
				text: modelData.lineId
				subText: qsTr("%1 - %2").arg(modelData.type).arg((new Date(modelData.time)).toString())
				icon.source: "qrc:/icons/" + modelData.type + ".svg"
				iconOverlay: false

				onClicked: {
					CutieModemSettings.modems[0].dial(modelData.lineId);
					CutieModemSettings.modems[0].audioMode = 1;
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
	}
}
