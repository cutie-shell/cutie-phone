import Cutie
import QtQuick

CutieWindow {
	id: mainWindow
	width: 400
	height: 800
	visible: false
	title: qsTr("Phone")

	onClosing: {
		visible = false;
		close.accepted = false;
	}

	Component.onCompleted: {
		CutieModemSettings.modems.forEach((m) => {
			m.newCall.connect(newCall);
		});
	}

	function view(dialno) {
		visible = true;
		if (dialno != "x") {
			CutieModemSettings.modems[0].dial(dialno);
			CutieModemSettings.modems[0].audioMode = 1;
		}
	}

	function newCall(call) {
		visible = true;
		if (pageStack.depth > 1) pageStack.replaceTop("qrc:/Call.qml", { call, lineId: call.data["LineIdentification"] });
		else pageStack.push("qrc:/Call.qml", { call, lineId: call.data["LineIdentification"] });
	}

	CutieStore {
		id: logStore
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
