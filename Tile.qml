import QtQuick 2.15
import QtGraphicalEffects 1.15

Rectangle {
    id: _tile
    color: "lightgreen"
    border.color: "black"
    border.width: 1
    radius: 10
    property string text: ""

    Image {
        id: backImage
        anchors.fill: parent
        source: "qrc:/img/tree-texture.jpg"
        visible: false
    }

    OpacityMask {
        anchors.fill: backImage
        source: backImage
        maskSource: Rectangle {
            width: backImage.width
            height: backImage.height
            radius: _tile.radius
            visible: false
        }
    }

    Text {
        id: tileText
        anchors.centerIn: parent
        text: parent.text
        font {
            pointSize: Math.min(parent.width, parent.height) / 3
            bold: true
        }
    }
}
