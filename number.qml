import QtQuick 2.0

import "root.js" as Root

Rectangle {
    color: number <= 1 ? "transparent" :
                         number <= 2 ? "grey" :
                                       number <= 4 ? "brown" :
                                                     number <= 8 ? "blue" :
                                                                   number <= 16 ? "yellow" :
                                                                                  number <= 32 ? "green" :
                                                                                                 number <= 64 ? "darkgreen" :
                                                                                                                number <= 128 ? "white" :
                                                                                                                                number <= 256 ? "pink" :
                                                                                                                                                number <= 512 ? "red" :
                                                                                                                                                                number <= 1024 ? "purple" :
                                                                                                                                                                                 number <= 2048 ? "darkblue" : "#3c3a32"

    property int xindex
    property int yindex
    property int number: 2

    property int xlogical
    property int ylogical
    property int numberlogical

    x: tiles.itemAt(xindex + root.rows*yindex).x
    y: tiles.itemAt(xindex + root.rows*yindex).y
    width: tiles.itemAt(xindex + root.rows*yindex).width
    height: tiles.itemAt(xindex + root.rows*yindex).height
    radius: 2

    Text {
        id: numberText
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: parent.number < 1 ? "" : parent.number
        fontSizeMode: Text.Fit
        font.pixelSize: parent.height
    }

    Behavior on x {
        NumberAnimation {
            duration: 50
        }
    }

    Behavior on y {
        NumberAnimation{
            duration: 50
        }
    }

    Behavior on number {
        NumberAnimation {
            duration: 50
        }
    }

    function move(x, y) {
        xindex = x
        yindex = y
        xlogical = x
        ylogical = y
    }

    function moveLeft() {
        var shouldSpawn = false

        for (var i = xlogical-1; i >= 0; --i){
            var tile = Root.getTileAt(i, ylogical)

            if (tile){
                if (tile.numberlogical == numberlogical){
                    scoreBoard.score += number*2

                    number = number + number
                    numberlogical = numberlogical * 2

                    Root.pop(i, ylogical)

                    move(i, ylogical)

                    shouldSpawn = true
                    return shouldSpawn
                }
                else {
                    return shouldSpawn
                }
            }
            else {
                move(i, ylogical)
                shouldSpawn = true
            }
        }

        return shouldSpawn
    }

    function moveRight() {
        var shouldSpawn = false

        for (var i = xlogical+1; i < root.columns; ++i){
            var tile = Root.getTileAt(i, ylogical)

            if (tile){
                if (tile.numberlogical == numberlogical){
                    scoreBoard.score += number*2

                    number = number + number
                    numberlogical = numberlogical*2

                    Root.pop(i, ylogical)

                    move(i, ylogical)

                    shouldSpawn = true
                    return shouldSpawn
                }
                else {
                    return shouldSpawn
                }
            }
            else {
                move(i, ylogical)
                shouldSpawn = true
            }
        }

        return shouldSpawn
    }

    function moveUp() {
        var shouldSpawn = false

        for (var j = ylogical-1; j >= 0; --j){
            var tile = Root.getTileAt(xlogical, j)

            if (tile){
                if (tile.numberlogical == numberlogical){
                    scoreBoard.score += number*2

                    number = number + number
                    numberlogical = numberlogical*2

                    Root.pop(xlogical, j)

                    move(xlogical, j)

                    shouldSpawn = true
                    return shouldSpawn
                }
                else {
                    return shouldSpawn
                }
            }
            else {
                move(xlogical, j)
                shouldSpawn = true
            }
        }

        return shouldSpawn
    }

    function moveDown() {
        var shouldSpawn = false

        for (var j = ylogical+1; j < root.rows; ++j){
            var tile = Root.getTileAt(xlogical, j)

            if (tile){
                if (tile.numberlogical == numberlogical){
                    scoreBoard.score += number*2

                    number = number + number

                    numberlogical = numberlogical*2

                    Root.pop(xlogical, j)

                    move(xlogical, j)

                    shouldSpawn = true
                    return shouldSpawn
                }
                else {
                    return shouldSpawn
                }
            }
            else {
                move(xlogical, j)
                shouldSpawn = true
            }
        }

        return shouldSpawn
    }
}
