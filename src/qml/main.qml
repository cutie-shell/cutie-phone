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
			floatIconName: "input-dialpad-symbolic"
			onFloatAction: {
				pageStack.push("qrc:/CallTo.qml", {})
			}

			header: CutiePageHeader {
				id: header
				title: mainWindow.title
			}

			delegate: CutieListItem {
				width: parent ? parent.width : 0
				id: litem
				text: modelData.lineId
				subText: qsTr("%1 - %2").arg(modelData.type).arg((new Date(modelData.time)).toString())
				icon.source: "qrc:/icons/" + modelData.type + ".svg"
				iconOverlay: false

				onClicked: {
					pageStack.push("qrc:/CallTo.qml", {
						predial: modelData.lineId
					});
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
