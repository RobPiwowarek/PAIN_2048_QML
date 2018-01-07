import QtQuick 2.6
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2

import "root.js" as Root

Window {
    id: root
    width: 600; height: 600
    color: "#888888"
    title: "2048"

    minimumWidth: gridLayout.Layout.minimumWidth
    minimumHeight: gridLayout.Layout.minimumHeight

    property int columns: 4
    property int rows: 4
    property variant numbers: []

    GridLayout {
        id: gridLayout
        anchors.fill: parent
        rows: 2

        Rectangle {
            Layout.row: 0
            Layout.fillWidth: true
            Layout.minimumHeight: 600*0.1
            Layout.minimumWidth: 200

            id: scoreBoard
            width: root.width; height: root.height * 0.1

            anchors.top: root.top
            opacity: 0.66
            color: "white"
            radius: 4

            property int score: 0

            RowLayout {
                id: layout
                anchors.fill: parent
                spacing: 6

                Button {
                    id: newButton
                    text: "new"

                    Layout.fillWidth: true
                    Layout.minimumWidth: 25
                    Layout.preferredWidth: 25
                    Layout.maximumWidth: scoreBoard.width/3
                    Layout.minimumHeight: scoreBoard.height/2

                    onClicked: Root.newGame()
                }

                Button {
                    text: "settings"

                    Layout.fillWidth: true
                    Layout.minimumWidth: 40
                    Layout.preferredWidth: 40
                    Layout.maximumWidth: scoreBoard.width/3
                    Layout.minimumHeight: scoreBoard.height/2

                    onClicked: dialog.open()
                }

                Text {
                    id: scoreBoardText

                    width: scoreBoard.width
                    height: scoreBoard.height
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    fontSizeMode: Text.Fit
                    font.pixelSize: parent.height/2
                    text: "Score: " + scoreBoard.score

                    Layout.fillWidth: true
                    Layout.minimumWidth: 25
                    Layout.preferredWidth: 25
                    Layout.maximumWidth: scoreBoard.width/3
                    Layout.minimumHeight: scoreBoard.height/2
                }
            }
        }

        Grid {
            Layout.row: 1
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 200
            Layout.minimumWidth: 200

            id: grid
            //width: root.width
            //height: root.height - scoreBoard.height

            columns: root.columns
            rows: root.rows

            spacing: 4

            property real tileWidth: (width - (columns - 1) * spacing) / columns
            property real tileHeight: (height - (rows - 1) * spacing) / rows

            Repeater {
                id: tiles
                model: root.columns * root.rows

                Rectangle {
                    width: parent.tileWidth
                    height: parent.tileHeight
                    color: "#AAAAAA"
                    radius: 2

                    property int xindex: index % root.columns
                    property int yindex: index / root.columns
                }

                function getEmptyTile(){
                    var emptyTiles = []

                    for (var i = 0; i < root.columns; ++i) {
                        for (var j = 0; j < root.rows; ++j) {
                            if (!Root.getTileAt(j, i)) {
                                emptyTiles.push(itemAt(j + root.rows*i))
                            }
                        }
                    }

                    var index = Math.floor(Math.random() * emptyTiles.length)

                    return emptyTiles[index];
                }
            }
        }

    }

    Item {
        anchors.fill: parent
        focus: true
        Keys.onLeftPressed: {
            Root.moveLeft()
        }

        Keys.onUpPressed: {
            Root.moveUp()
        }

        Keys.onDownPressed: {
            Root.moveDown();
        }

        Keys.onRightPressed: {
            Root.moveRight();
        }
    }

    Dialog {
        id: dialog
        modality: Qt.WindowModal
        title: "Settings"

        onButtonClicked: {
            if (clickedButton === StandardButton.Ok && answer.value >= 3 && answer.value <= 10){
                root.columns = answer.value;
                root.rows = answer.value;
                Root.newGame()
            }
            else{
                root.columns = 4
                root.rows = 4
            }

        }

        ColumnLayout {
            id: column
            width: parent.width

            Label {
                text: "Board Size (<3, 10>)"
                Layout.columnSpan: 2
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                SpinBox {
                    id: answer
                    onEditingFinished: dialog.click(StandardButton.Ok)
                }

            }
        }
    }

    Component.onCompleted: Root.generate()
}
