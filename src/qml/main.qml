import Cutie
import Cutie.Modem
import Cutie.Phonenumber
import Cutie.Store
import QtQuick

CutieWindow {
	id: mainWindow
	width: 400
	height: 800
	title: qsTr("Phone")

	property string localISO: CutiePhonenumberHelper.MCCtoISO(
		CutieModemSettings.modems[0].networkCountryCode)

	function predial(number) {
		pageStack.push("qrc:/CallTo.qml", {
			predial: number
		});
	}

	function nameForNumber(number) {
		let sender = CutiePhonenumberHelper.createPhonenumber(number, mainWindow.localISO);
		if ("contacts" in contactStore.data)
			for (let i = 0; i < contactStore.data.contacts.length; i++) {
				let contact = contactStore.data.contacts[i]
				let contactNumber = CutiePhonenumberHelper.createPhonenumber(
					contact.PhoneNumber, mainWindow.localISO);
				if (sender.locallyEqualTo(contactNumber, mainWindow.localISO)) {
					return contact.FirstName + " " + contact.LastName;
				}
			}
		return number;
	}

	CutieStore {
		id: logStore
		appName: "cutie-phone"
		storeName: "callLog"
	}

	CutieStore {
		id: contactStore
		appName: "cutie-contacts"
		storeName: "contacts"
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
				text: nameForNumber(modelData.lineId)
				subText: qsTr("%1 - %2").arg(modelData.type).arg((new Date(modelData.time)).toString())
				icon.source: "image://icon/call-" + modelData.type.toLowerCase() + "-symbolic"
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
