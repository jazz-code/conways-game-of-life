// importing controlP5 library
import controlP5.*;
ControlP5 cp5;

// Size of cell
int cellSize = 10;

int randomCellSpawn = 15;

// Variables for timer
int interval = 100;
int lastRecordedTime = 0;

// Array of Cells
int[][] cells;
int[][] cellsBuffer;

boolean running = true;

//Cell colors alive/dead
color alive = color(0, 200, 0);
color dead = color(0);

  
void setup() {
  size(840, 560);
  fill(100);
  rect(130, 130, 1900, 1600);
  //fill(200);
  stroke(20);
  strokeWeight(2);
  
  //Instantiate cell arrays
  cells = new int[width/cellSize][height/cellSize];
  cellsBuffer = new int[width/cellSize][height/cellSize];
  
  //Initialize cell
  for (int x = 0; x < width/cellSize; x++) {
    for (int y =0; y < height/cellSize; y++) {
      // Random cell spawn at start        
      float state = random(100);
      if (state > randomCellSpawn) {
        state = 0;
      } else {
        state = 1;
      }
      cells[x][y] = int(state); // Save state of each cell
    }
  }
  background(0);

  
  // Game Board
  //fill(200);
  //rect(0, 0, 1900, 1600);
  cp5 = new ControlP5(this);
    cp5 = new ControlP5(this);
    cp5.addSlider("mySlider");
    text("speed",0,0);
    cp5.addButton("myButton");

}

void draw(){
  //Draw Grid
  for (int x = 0; x < width/cellSize; x++) {
    for (int y =0; y < height/cellSize; y++) {
      if (cells[x][y] == 1) { // If alive
        fill(alive);
      } else { // Else dead
        fill(dead);
      }
      //Draw rectangle cell
      rect(x*cellSize, y*cellSize, cellSize, cellSize);
    }
  }
  
  // Create cells on click, while not running
  if (!running && mousePressed) {
    // Position of X cell converted mouseX, from 0 - width,
    // into a value that ranges from the left edge of the window (0) to the right edge (width).
    int cellPosX = int(map(mouseX, 0, width, 0, width/cellSize));
    // Constrain X within bounds( constrain(value, low, high) )
    cellPosX = constrain(cellPosX, 0, width/cellSize-1);
    int cellPosY = int(map(mouseY, 0, width, 0, width/cellSize));
    // Constrain Y within bounds
    cellPosY = constrain(cellPosY, 0, width/cellSize-1);
  
  // Checking against cells in buffer matrix
  if (cellsBuffer[cellPosX][cellPosY] == 1) { // Cell is alive
    cells[cellPosX][cellPosY] = 0; // Kill cell
    fill(dead); // Fill with dead color
    } else {
      cells[cellPosX][cellPosY] = 1; // Make cell alive
      fill(alive); // Fill with alive color
    }
  } // Saving to buffer when mouse goes up
  else if (!running && !mousePressed) {
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }
  }
  // Iterate if timer ticks
  if (millis()-lastRecordedTime>interval) {
    if (running) {
      lifeCycle();
      lastRecordedTime = millis();
    }
  }
}

void lifeCycle() {
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }
  // Visit each cell in matrix:
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      // And visit all the neighbours of each cell
      int neighbours = 0;
      for (int xx = x-1; xx <= x+1; xx++) {
        for (int yy = y-1; yy <= y+1; yy++) {  
          // Keeping within bounds
          if (((xx >= 0)&&(xx < width/cellSize))&&((yy >= 0)&&(yy <height/cellSize))) { 
            // Skip current self cell
            if (!((xx==x)&&(yy==y))) {
              // Find alive neighbors, increment
              if (cellsBuffer[xx][yy]==1) {
                neighbours++; 
              }
            } // End of if
          } // End of if
        } // End of yy loop
      } //End of xx loop
      
      // Game of Life rules!
      if (cellsBuffer[x][y]==1) { // If cell is alive
        if (neighbours < 2 || neighbours > 3) {  // and has 2 or 3 neighbours
          cells[x][y] = 0; // Die unless it has 2 or 3 neighbours
        }
      } 
      else { // The cell is dead
        if (neighbours == 3 ) {
          cells[x][y] = 1; // Make alive only if it has 3 neighbours
        }
      }
    } 
  } 
}

void keyPressed() {
  if (key=='r' || key == 'R') {
    // Restart: reinitialization of cells
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        float state = random (100);
        if (state > randomCellSpawn) {
          state = 0;
        }
        else {
          state = 1;
        }
        cells[x][y] = int(state); // Save state of each cell
      }
    }
  }
  if (key==' ') { // On/off of pause
    running = !running;
  }
  if (key == 'c') { // clear all
    for (int x = 0; x < width/cellSize; x++) {
      for (int y = 0; y < height/cellSize; y++) {
        cells[x][y] = 0;
      
      }
    }
  }
}
