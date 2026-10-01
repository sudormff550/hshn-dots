import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

PanelWindow {
    id: window

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 30
    color: Colors.surface

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8

        Row {
            spacing: 12
            Layout.alignment: Qt.AlignVCenter

            Repeater {
                model: 9

                delegate: Text {
                    required property int index
                    property bool isActive: Boolean(tagTracker.activeMap[index + 1])
                    property bool hasClients: Boolean(tagTracker.clientMap[index + 1] > 0)
                    text: (index + 1).toString()
                    color: isActive ? Colors.primary : (hasClients ? Colors.secondary : "#808080")

                    font.pixelSize: 18
                    font.bold: isActive
                    font.underline: isActive
                    font.family: "JetBrainsMono Nerd Font"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            tagSwitcher.exec(["mmsg", "-t", (index + 1).toString()])
                        }
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }
    }

    Process { id: tagSwitcher }


    Process {
        id: initialFetch
        command: ["mmsg", "get", "all-tags"]
        running: true

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => tagTracker.parseJson(data)
        }
    }


    Process {
        id: tagTracker

        property var activeMap: ({})
        property var clientMap: ({})

        command: ["mmsg", "watch", "all-tags"]
        running: true

        function parseJson(data) {
            const line = data.trim()
            if (!line) return

            try {
                const parsed = JSON.parse(line)
                let activeUpdates = Object.assign({}, tagTracker.activeMap)
                let clientUpdates = Object.assign({}, tagTracker.clientMap)


                if (parsed.all_tags) {
                    for (const mon of parsed.all_tags) {
                        if (mon.tags) {
                            for (const tag of mon.tags) {
                                activeUpdates[tag.index] = tag.is_active
                                clientUpdates[tag.index] = tag.client_count || 0
                            }
                        }
                    }
                } 

                else if (parsed.tags) {
                    for (const tag of parsed.tags) {
                        activeUpdates[tag.index] = tag.is_active
                        clientUpdates[tag.index] = tag.client_count || 0
                    }
                } 

                else if (parsed.index !== undefined) {
                    activeUpdates[parsed.index] = parsed.is_active
                    clientUpdates[parsed.index] = parsed.client_count || 0
                }

                tagTracker.activeMap = activeUpdates
                tagTracker.clientMap = clientUpdates
            } catch (e) {

            }
        }

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => tagTracker.parseJson(data)
        }
    }
}
