// Array functions
function transpose(matrix) {
  const rows = matrix.length, cols = matrix[0].length;
  const grid = [];
  for (let j = 0; j < cols; j++) {
    grid[j] = Array(rows);
  }
  for (let i = 0; i < rows; i++) {
    for (let j = 0; j < cols; j++) {
      grid[j][i] = matrix[i][j];
    }
  }
  return grid;
}

function moveBack(arr) {
  for (var ii = 0; ii < arr.length-1; ii++) {
    arr[ii] = arr[ii+1];
  }
  return arr;
}


function atLeastOne(arr) {
  for (var i = 0; i < arr.length; i++) {
    if (arr[i].moveable) {
      return true;
    }
  }
  return false;
}
function farthestLeftSquare() { 
  for (var i = 0; i < squares.length; i++) { 
    if (atLeastOne(squares[i])) { 
      return i+1;
    }
  } 
  return 1;
}
function farthestRightSquare() { 
  for (var i = squares.length-1; i >= 0; i--) { 
    if (atLeastOne(squares[i])) { 
      return i+1;
    }
  } 
  return squares.length;
}
function highestSquare() { 
  var transposed = transpose(squares); 
  for (var i = 0; i < transposed.length; i++) {
    if (atLeastOne(transposed[i])) { 
      return i+1;
    }
  } 
  return 1;
}
function lowestSquare() { 
  var transposed = transpose(squares); 
  for (var i = transposed.length-1; i >= 0; i--) { 
    if (atLeastOne(transposed[i])) { 
      return i+1;
    }
  } 
  return squares.length;
}

function addX(p, add) { 
  if (p.x >= 1 || p.x < BOARD_WIDTH) { 
    p.x += add;
  }
}
function addY(p, add) { 
  if (p.y >= 1 || p.y < BOARD_HEIGHT) { 
    p.y += add;
  }
}

function Point(x, y) {
  return new PointClass(x, y);
}
class PointClass {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
}

function dimensions(w, h, rad) { 
  return new Dimensions(w, h, rad);
}
class Dimensions {
  constructor(w, h, rad) { 
    this.w = w; 
    this.h = h; 
    this.rad = rad;
  }
}

function txt(string, size, x, y) { 
  fill(0); 
  textSize(size); 
  textAlign(CENTER, CENTER); 
  text(string, x, y); 
  noFill();
}





class Square {
  constructor(c, n) { 
    this.c = c; 
    this.number = n; 
    this.moveable = true;
  }

  show(x, y, w) {
    if (this.moveable) {
      fill(this.c);
      rect(x, y, w, w);
      noFill();
      txt(str(this.number), 32, x + w/2, y + w/2);
    }
  }

  show(x, y, w, rad) {
    if (this.moveable) {
      fill(this.c);
      rect(x, y, w, w, rad);
      noFill();
      txt(str(this.number), 32, x + w/2, y + w/2);
    }
  }
}





function keyPressed() {
  // The user cannot go past the farthest visible number in any direction
  if ((key == 'w' || keyCode == UP_ARROW) && position.y > highestSquare()) { 
    addY(position, -1); 
    LEGAL_KEY = true;
  }
  if ((key == 'a'  || keyCode == LEFT_ARROW) && position.x > farthestLeftSquare()) { 
    addX(position, -1); 
    LEGAL_KEY = true;
  }
  if ((key == 's' || keyCode == DOWN_ARROW) && position.y < lowestSquare()) { 
    addY(position, 1);  
    LEGAL_KEY = true;
  }
  if ((key == 'd' || keyCode == RIGHT_ARROW) && position.x < farthestRightSquare()) { 
    addX(position, 1);  
    LEGAL_KEY = true;
  }


  if (LEGAL_KEY && squares[position.x-1][position.y-1].moveable == true) {
    // Performs operator on previous value and current value
    if      (operations[0] == "+") { 
      value += squares[position.x-1][position.y-1].number;
    } else if (operations[0] == "-") { 
      value -= squares[position.x-1][position.y-1].number;
    } else if (operations[0] == "*") { 
      value *= squares[position.x-1][position.y-1].number;
    } else if (operations[0] == "/") {
      // Don't want to divide by zero
      if (squares[position.x-1][position.y-1].number == 0) {
        alert("YOU DIVIDED BY ZERO!\n Your final score: Undefined")
        resetGame();
        return;
      }
      else {
        value /= squares[position.x-1][position.y-1].number;
      }
    } 

    // Change current operator every time a move happens
    moveBack(operations);
    operations[operations.length-1] = POSSIBLE_OPERATIONS[int(random(POSSIBLE_OPERATIONS.length))];
  }
  squares[position.x-1][position.y-1].moveable = false;



  // Check if there are anymore numbers left
  if (LEGAL_KEY) {
    var cont = false;
    for (var i = 0; i < squares.length; i++) { 
      for (var ii = 0; ii < squares[i].length; ii++) { 
        if (squares[i][ii].moveable == true) { 
          cont = true; 
          break;
        }
      }
    }
    // No more squares left
    if (cont == false) {
      alert("There are no more squares.\n Your final score: " + value);
      resetGame();
      return;
    }
  }
}




function draw() {
  background(255);

  // Text with current operations and current value
  txt("Operations: (" + join(operations, ", ") + "). Current Operation: \"" + operations[0] + "\"", 32, width/4, 32);
  txt("Value: " + value, 32, width/4, 64);


  //Draws the current position as black
  fill(0);
  rect((width/2)/3, (height-TEXT_SPACE)/3+TEXT_SPACE, (width/2)/3, (height-TEXT_SPACE)/3, 10);
  noFill();

  // Draws one square around the current position in every direction
  var x=0, y=TEXT_SPACE;
  for (var xi = position.x-1; xi <= position.x+1; xi++) {
    for (var yi = position.y-1; yi <= position.y+1; yi++) {
      // FIXME Square farthest to the (left, right, top left)
      try { 
        squares[xi-1][yi-1].show(x, y, (width/2)/3, 10);
      }
      catch (ArrayIndexOutOfBoundsException) {
      }
      y += float((height-TEXT_SPACE)/3);
    }
    x += float((width/2)/3);
    y = TEXT_SPACE;
  }


  // Draws the map on the right of the screen with the squares you've already been on
  stroke(0);
  var w = (width/2)/BOARD_HEIGHT, h = (height-TEXT_SPACE)/BOARD_HEIGHT;
  for (var i = 0; i < squares.length; i++) {
    for (var ii = 0; ii < squares[0].length; ii++) {
      if (position.x-1 == i && position.y-1 == ii) { 
        fill(0);
      } else if (squares[i][ii].moveable == false) { 
        fill(102, 255, 102);
      } else { 
        fill(255, 51, 51);
      }
      rect(float(i*w+(width/2)), float(ii*h+TEXT_SPACE), w, h);
    }
  }
  noFill();
}




// Primitive variables
var position;
var MIN_RAND;
var MAX_RAND;
var BOARD_WIDTH;
var BOARD_HEIGHT;
var TEXT_SPACE;
var prev_value;
var value = 0;
var LEGAL_KEY;
var DIV_BY_ZERO = false;
// Object variables
var squares;
var POSSIBLE_OPERATIONS;
var operations = [];


function setup() {
  TEXT_SPACE = 100;
  createCanvas(1600, 800+TEXT_SPACE);
  resetGame();
}


function resetGame() {
  // Creating values for the variables
  MIN_RAND = 0;
  MAX_RAND = 15;
  BOARD_WIDTH = 10;
  BOARD_HEIGHT = 10;
  prev_value = -1;
  value = 0;
  LEGAL_KEY = false;
  squares = [];
  POSSIBLE_OPERATIONS = ["+", "-", "/", "*"];
  position = Point(round(random(1, BOARD_WIDTH+0.5)), round(random(1, BOARD_HEIGHT+0.5)));

  // Populates the board with random numbers
  for (var i = 0; i < BOARD_WIDTH; i++) {
    squares[i] = [];
    for (var ii = 0; ii < BOARD_HEIGHT; ii++) {
      // No square on the starting position
      // FIX ME Change the 1 to a zero
      if (position.x-1 == i && position.y-1 == ii) {
        squares[i].push(new Square(color(240, 128, 128), 1));
        squares[i][ii].moveable = false;
      } else {
        squares[i].push(new Square(color(240, 128, 128), int(random(MIN_RAND, MAX_RAND+1))));
      }
    }
  }
  // Determines the first four operations
  for (var ii = 0; ii < 4; ii++) {
    operations[ii] = POSSIBLE_OPERATIONS[int(random(POSSIBLE_OPERATIONS.length))];
  }
  
  DIV_BY_ZERO = false;
}
