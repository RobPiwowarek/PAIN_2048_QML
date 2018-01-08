var isMoving = false

function getTileAt(x, y) {
    for (var i = 0; i < numbers.length; ++i) {
        if (numbers[i].xindex == x && numbers[i].yindex == y)
            return numbers[i]
    }
}

function pop(x, y){
    for (var i = 0; i < numbers.length; ++i){
        if (numbers[i].xindex == x && numbers[i].yindex == y){
            numbers[i].destroy()
            numbers.splice(i, 1)
        }
    }
}

function spawn() {
    var component = Qt.createComponent("number.qml")

    if (component.status == Component.Ready) {
        var tile = tiles.getEmptyTile()

        if (Math.random() * 2 > 1)
            root.numbers.push(component.createObject(tiles, {"xindex": tile.xindex, "yindex": tile.yindex, "number": 4, "xlogical": tile.xindex, "ylogical": tile.yindex, "numberlogical": 4}))
        else
            root.numbers.push(component.createObject(tiles, {"xindex": tile.xindex, "yindex": tile.yindex, "number": 2, "xlogical": tile.xindex, "ylogical": tile.yindex, "numberlogical": 2}))
    }
}

function generate() {
    var component = Qt.createComponent("number.qml")

    if (component.status == Component.Ready) {
        root.numbers.push(component.createObject(tiles, {"xindex": 2, "yindex": 0, "number": 2, "xlogical": 2, "ylogical": 0, "numberlogical": 2}));
        root.numbers.push(component.createObject(tiles, {"xindex": 1, "yindex": 1, "number": 4, "xlogical": 1, "ylogical": 1, "numberlogical": 4}));
    }
}

function newGame(){
    for (var i = 0; i < numbers.length; ++i){
        numbers[i].destroy()
    }

    scoreBoard.score = 0

    numbers = new Array()

    generate()
}

function moveLeft() {
    var shouldSpawn = false
    isMoving = true

    timer.start()
    for (var i = 0; i < rows; ++i)
        for (var j = 0; j < columns; ++j) {
            var tile = getTileAt(j, i)

            if (!tile)
                continue

            if (tile.moveLeft())
                shouldSpawn = true
        }

    if (shouldSpawn){
        spawn()
    }
}

function moveRight() {
    var shouldSpawn = false
    isMoving = true
    timer.start()

    for (var i = 0; i < rows; ++i)
        for (var j = rows-1; j >= 0; --j) {
            var tile = getTileAt(j, i)

            if (!tile)
                continue

            if (tile.moveRight())
                shouldSpawn = true
        }

    if (shouldSpawn){
        spawn()
    }
}

function moveUp() {
    var shouldSpawn = false
    isMoving = true
    timer.start()

    for (var i = 0; i < rows; ++i)
        for (var j = 0; j < columns; ++j) {
            var tile = getTileAt(j, i)

            if (!tile)
                continue

            if (tile.moveUp())
                shouldSpawn = true
        }

    if (shouldSpawn){
        spawn()
    }
}

function moveDown() {
    var shouldSpawn = false
    isMoving = true
    timer.start()

    for (var i = rows-1; i >= 0; --i)
        for (var j = 0; j < columns; ++j) {
            var tile = getTileAt(j, i)

            if (!tile)
                continue

            if (tile.moveDown())
                shouldSpawn = true
        }

    if (shouldSpawn){
        spawn()
    }
}

function stoppedMoving() {
    isMoving = false
}

function isGameOver() {
    for (var i = 0; i < root.rows; ++i)
        for (var j = 0; j < root.columns; ++j){
            if (!getTileAt(j, i))
                return false
            if (getTileAt(j+1, i) && getTileAt(j+1, i).numberlogical == getTileAt(j, i).numberlogical)
                return false
            if (getTileAt(j-1, i) && getTileAt(j-1, i).numberlogical == getTileAt(j, i).numberlogical)
                return false
            if (getTileAt(j, i+1) && getTileAt(j, i+1).numberlogical == getTileAt(j, i).numberlogical)
                return false
            if (getTileAt(j, i-1) && getTileAt(j, i-1).numberlogical == getTileAt(j, i).numberlogical)
                return false
        }

    return true
}
