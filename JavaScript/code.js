var grid = [{ "x": 4, "y": 9 }, { "x": 5, "y": 9 }, { "x": 6, "y": 9}, { "x": 6, "y":  8}, { "x": 6, "y": 7}, { "x": 5, "y": 7}, { "x": 4, "y": 7}, { "x": 4, "y": 8 }]

function sleep (time) {
  return new Promise((resolve) => setTimeout(resolve, time));
}

function filterArray(src, filt) {
    // Det här är fan genialt, tack so

    var temp = {}, i, result = [];
    
    for (i = 0; i < filt.length; i++) {
        temp[filt[i].x + " " + filt[i].y] = true;
    }
    
    for (i = 0; i < src.length; i++) {
        if (!(src[i].x + " " + src[i].y in temp)) {
            result.push(src[i]);
        }
    }
    return(result);
}

function getBounds() {
    var maxX = 0
    var maxY = 0
    var minX = grid[0].x
    var minY = grid[0].y

    for (var i = 0; i < grid.length; i++) {
        if (grid[i].x > maxX) {
            maxX = grid[i].x
        }
        else if (grid[i].x < minX) {
            minX = grid[i].x
        }

        if (grid[i].y > maxY) {
            maxY = grid[i].y
        }
        else if (grid[i].y < minY) {
            minY = grid[i].y
        }
    }

    return {
        "first": {
            "x": minX - 1,
            "y": maxY + 1
        },
        "second": {
            "x": maxX + 1,
            "y": minY - 1
        }
    }
}

function forCellInBounds(bounds, cell) {
    var x = bounds.first.x
    while (x <= bounds.second.x) {
        var y = bounds.second.y 
        while (y <= bounds.first.y) {
            cell({"x": x, "y": y})
            y++
        }
        x++
    }
}

function isAlive(pos) {
    for (var i = 0; i < grid.length; i++) {
        if (grid[i].x == pos.x && grid[i].y == pos.y) {
            return true
        }
    }

    return false
}

function getNeigbors(cell) {
    var neighbors = 0

    const bounds = {
        "first": {
            "x": cell.x - 1,
            "y": cell.y + 1
        },
        "second": {
            "x": cell.x + 1,
            "y": cell.y - 1
        }
    }

    forCellInBounds(bounds, function(pos) {
        const isThisCell = pos.x == cell.x && pos.y == cell.y
        if (isAlive(pos) && !isThisCell) {
            neighbors++
        }
    })

    return neighbors
}

function step() {
    const bounds = getBounds()

    var deadCells = []
    var liveCells = []
    
    forCellInBounds(bounds, function(pos) {
        const neighbors = getNeigbors(pos)

        if (isAlive(pos)) {
            if (neighbors < 2) { // Die
                deadCells.push(pos)
            }
            else if (neighbors == 2 || neighbors == 3) { // Survive
                // Do nothing
            }
            else if (neighbors > 3) { // Die
                deadCells.push(pos)
            }
        }
        else {
            if (neighbors == 3) { // Birth
                liveCells.push(pos)
            }
        }
    })

    // Remove new dead cells
    grid = filterArray(grid, deadCells)

    // Add new living cells
    grid = grid.concat(liveCells)

    // Temporary printing method
    display()

    sleep(2000).then(() => {
        step()
    });
}

function display() {
    var column = 0
    document.getElementById("output").innerHTML = ""

    forCellInBounds(getBounds(), function(pos) {
        if (column != pos.x) {
            column = pos.x
            document.getElementById("output").innerHTML += "\n"
        }

        if (isAlive(pos)) {
            document.getElementById("output").innerHTML += "X"
        }
        else {
            document.getElementById("output").innerHTML += " "
        }
    })
}

step()