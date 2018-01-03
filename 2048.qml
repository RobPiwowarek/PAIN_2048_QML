import QtQuick 2.6
import QtGraphicalEffects 1.0

Rectangle {
    id: root
    width: 600; height: 600
    color: "#888888"

    property int columns: 4
    property int rows: 4
    property variant numbers: []

    Rectangle {
        id: scoreBoard
        width: parent.width; height: parent.height * 0.1

        anchors.top: parent.top
        opacity: 0.66
        color: "white"
        radius: 4
    }

    Grid {
        id: grid
        width: parent.width
        height: parent.height - scoreBoard.height

        columns: root.columns
        rows: root.rows

        spacing: 4

        property real tileWidth: (width - (columns - 1) * spacing) / columns
        property real tileHeight: (height - (rows - 1) * spacing) / rows

        anchors.bottom: parent.bottom

        Repeater {
            id: tiles
            model: root.columns * root.rows

            Rectangle {
                width: parent.tileWidth
                height: parent.tileHeight
                color: "#AAAAAA"
                radius: 2
            }

            function getEmptyTile(){
                var emptyTiles = []
                for (var i = 0; i < root.columns; i++) {
                    for (var j = 0; j < root.rows; j++) {
                        if (!root.numbers[j + root.width*i]) {
                            emptyTiles.push(itemAt(j + root.width*i))
                        }
                    }
                }
                return emptyTiles[Math.floor(Math.random * emptyTiles.length)];
            }
        }
    }

    Component {
        Rectangle {
            id: number
            color: number <= 1 ? "transparent" :
                                 number <= 2 ? "grey" :
                                               number <= 4 ? "brown" :
                                                             number <= 8 ? "blue" :
                                                                           number <= 16 ? "yellow" :
                                                                                          number <= 32 ? "green" :
                                                                                                         number <= 64 ? "dark-green" :
                                                                                                                        number <= 128 ? "white" :
                                                                                                                                        number <= 256 ? "pink" :
                                                                                                                                                        number <= 512 ? "red" :
                                                                                                                                                                        number <= 1024 ? "purple" :
                                                                                                                                                                                         number <= 2048 ? "dark-blue" : "#3c3a32"

            property int xindex
            property int yindex
            property int number: 2

            x: tiles.itemAt(xindex + root.width*yindex).x
            y: tiles.itemAt(xindex + root.height*yindex).y
            width: tiles.itemAt(xindex + root.width*yindex).width
            height: tiles.itemAt(xindex + root.width*yindex).height
            radius: 2
        }
    }
}
