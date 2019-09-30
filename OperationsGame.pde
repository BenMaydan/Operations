import java.awt.Point;


// Array functions
Square[][] transpose(Square[][] arr) {
  Square[][] nArr = new Square[arr[0].length][arr.length];
  int i, j; 
  for (i = 0; i < squares[0].length; i++) 
    for (j = 0; j < squares.length; j++) 
      nArr[i][j] = arr[j][i]; 
  return nArr;
}
String[] moveBack(String[] arr) { for (int ii = 0; ii < arr.length-1; ii++) { arr[ii] = arr[ii+1]; } return arr; }
boolean atLeastOne(Square[] arr) { for (Square element : arr) { if (element.moveable == true) { return true; } } return false; }
int farthestLeftSquare() { for (int i = 0; i < squares.length; i++) { if (atLeastOne(squares[i])) { return i+1; } } return 1; }
int farthestRightSquare() { for (int i = squares.length-1; i >= 0; i--) { if (atLeastOne(squares[i])) { return i+1; } } return squares.length; }
int highestSquare() { Square[][] transposed = transpose(squares); for (int i = 0; i < transposed.length; i++) {if (atLeastOne(transposed[i])) { return i+1; } } return 1; }
int lowestSquare() { Square[][] transposed = transpose(squares); for (int i = transposed.length-1; i >= 0; i--) { if (atLeastOne(transposed[i])) { return i+1; } } return squares.length; }

void addX(Point p, int add) { if (p.x >= 1 || p.x < BOARD_WIDTH) { p.x += add; } }
void addY(Point p, int add) { if (p.y >= 1 || p.y < BOARD_HEIGHT) { p.y += add; } }
Dimensions dimensions(float w, float h, float rad) { return new Dimensions(w, h, rad); }
class Dimensions { public float w, h, rad; Dimensions(float w, float h, float rad) { this.w = w; this.h = h; this.rad = rad; } }

void txt(String text, float size, float x, float y) { fill(0); textSize(size); textAlign(CENTER, CENTER); text(text, x, y); noFill(); }





class Square {
  public boolean moveable;
  public color c;
  public int number;
  Square(color c, int n) { this.c = c; this.number = n; this.moveable = true; }
  
  public void show(Point p, float w) {
    if (this.moveable) {
      fill(this.c);
      rect(p.x, p.y, w, w);
      noFill();
      txt(Integer.toString(this.number), 32, p.x + w/2, p.y + w/2);
    }
  }
  
  public void show(Point p, float w, float rad) {
    if (this.moveable) {
      fill(this.c);
      rect(p.x, p.y, w, w, rad);
      noFill();
      txt(Integer.toString(this.number), 32, p.x + w/2, p.y + w/2);
    }
  }
}





void keyPressed() {
  // The user cannot go past the farthest visible number in any direction
  if ((key == 119 || (key == CODED && keyCode == UP))    && pos.y > highestSquare())         { addY(pos, -1); LEGAL_KEY = true; }  // W
  if ((key == 97  || (key == CODED && keyCode == LEFT))  && pos.x > farthestLeftSquare())    { addX(pos, -1); LEGAL_KEY = true; }  // A
  if ((key == 115 || (key == CODED && keyCode == DOWN))  && pos.y < lowestSquare())          { addY(pos, 1);  LEGAL_KEY = true; }  // S
  if ((key == 100 || (key == CODED && keyCode == RIGHT)) && pos.x < farthestRightSquare())   { addX(pos, 1);  LEGAL_KEY = true; }  // D

  
  if (LEGAL_KEY && squares[pos.x-1][pos.y-1].moveable == true) {
    // Performs operator on previous value and current value
    if      (operations[0] == "+") { value += squares[pos.x-1][pos.y-1].number; }
    else if (operations[0] == "-") { value -= squares[pos.x-1][pos.y-1].number; }
    else if (operations[0] == "*") { value *= squares[pos.x-1][pos.y-1].number; } 
    else if (operations[0] == "/") {
      // Don't want to divide by zero
      try { value /= squares[pos.x-1][pos.y-1].number; }
      catch (ArithmeticException e) { background(255); txt("YOU DIVIDED BY ZERO!\n Your final score: Undefined", 32, width/2, height/2); noLoop(); }
    } 
    
    // Change current operator every time a move happens
    moveBack(operations);
    operations[operations.length-1] = POSSIBLE_OPERATIONS[(int)random(POSSIBLE_OPERATIONS.length)];
  }
  squares[pos.x-1][pos.y-1].moveable = false;



  // Check if there are anymore numbers left
  if (LEGAL_KEY) {
    boolean cont = false;
    for (Square[] xlist : squares) { for (Square sqr : xlist) { if (sqr.moveable == true) { cont = true; break; } } }
    // No more squares left
    if (cont == false) {
      background(255);
      txt("There are no more squares.\n Your final score: " + value, 32, width/2, height/2);
      noLoop();
    }
  }
}




void draw() {
  background(255);
  
  // Text with current operations and current value
  txt("Operations: (" + join(operations, ", ") + "). Current Operation: \"" + operations[0] + "\"", 32, width/4, 32);
  txt("Value: " + value, 32, width/4, 64);
  
  // Draws one square around the current position in every direction
  int x=0, y=TEXT_SPACE;
  for (int xi = pos.x-1; xi <= pos.x+1; xi++) {
    for (int yi = pos.y-1; yi <= pos.y+1; yi++) {
      // FIXME Square farthest to the (left, right, top left)
      try { squares[xi-1][yi-1].show(new Point(x, y), (width/2)/3, 10); }
      catch (ArrayIndexOutOfBoundsException e) {  }
      y += (height-TEXT_SPACE)/3;
    }
    x += (width/2)/3;
    y = TEXT_SPACE;
  }

  
  // Draws the map on the right of the screen with the squares you've already been on
  stroke(0);
  int w = (width/2)/BOARD_HEIGHT, h = (height-TEXT_SPACE)/BOARD_HEIGHT;
  for (int i = 0; i < squares.length; i++) {
    for (int ii = 0; ii < squares[0].length; ii++) {
      if (pos.x-1 == i && pos.y-1 == ii) { fill(0); rect(i*w+(width/2), ii*h+TEXT_SPACE, w, h); noFill(); }
      else if (squares[i][ii].moveable == false) { fill(102, 255, 102); rect(i*w+(width/2), ii*h+TEXT_SPACE, w, h); noFill(); }
      else { fill(255, 51, 51); rect(i*w+(width/2), ii*h+TEXT_SPACE, w, h); noFill(); }
    }
  }
  noFill();
}




// Primitive variables
Point pos;
short MIN_RAND = 1;
short MAX_RAND = 15;
short BOARD_WIDTH = 5;
short BOARD_HEIGHT = 5;
short TEXT_SPACE = 100;
int prev_value;
int value;
boolean LEGAL_KEY;
// Object variables
Square[][] squares = new Square[BOARD_WIDTH][BOARD_HEIGHT];
String[] POSSIBLE_OPERATIONS = new String[] {"+", "-", "/", "*"};
String[] operations = new String[4];

void settings() { size(1600, 800+TEXT_SPACE); }
void setup() {
  pos = new Point(round(random(1, BOARD_WIDTH+0.5)), round(random(1, BOARD_HEIGHT+0.5)));
  
  // Populates the board with random numbers
  for (int i = 0; i < BOARD_WIDTH; i++) {
    for (int ii = 0; ii < BOARD_HEIGHT; ii++) {
      // No square on the starting position
      // FIX ME Change the 1 to a zero
      if (pos.x-1 == i && pos.y-1 == ii) { squares[i][ii] = new Square(color(240, 128, 128), 1); squares[i][ii].moveable = false; }
      else { squares[i][ii] = new Square(color(240, 128, 128), (int)random(MIN_RAND, MAX_RAND+1)); }
    }
  }
  
  // Determines the first four operations
  for (int ii = 0; ii < 4; ii++) {
    operations[ii] = POSSIBLE_OPERATIONS[(int)random(POSSIBLE_OPERATIONS.length)];
  }
}
