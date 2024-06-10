import QtQuick 2.15

Rectangle {
    id: _endScreen
    property alias _restart: _restart
    property int shifts: 0
    property string time: ""
    Image {
        anchors.fill: _endScreen
        source: "qrc:/img/gray-stone.jpg"
    }
    Text {
        horizontalAlignment: Text.AlignHCenter
        id: _endScreenText
        anchors {
            top: _endScreen.top
            topMargin: 100
            horizontalCenter: _endScreen.horizontalCenter
        }
        text: "Congratulations!\nNumber of shifts: " + parent.shifts + "\ntime: " + parent.time
        color: "white"
        font.pointSize: 36
    }
    Rectangle {
        anchors {
            top: _endScreenText.bottom
            topMargin: 130
            horizontalCenter: _endScreen.horizontalCenter
        }

        width: 200
        height: 60
        color: _restart.containsMouse ? "#ad865a" : "#c69663"
        radius: 5
        Text {
            text: "Restart"
            anchors.centerIn: parent
            color: "#111"
            font.pointSize: 18
        }

        MouseArea {
            id: _restart
            anchors.fill: parent
            hoverEnabled: true
            HoverHandler {
                cursorShape: Qt.PointingHandCursor
            }
        }
    }
}
