// GridDesigner
// Grid base graphic design tool by pixel art like drawing method
// doc1oo

final int ALGO_ELLIPSE_DOT = 0;
final int ALGO_JOINT_LINE = 1;

int pixelSize = 40;
int canvas[][][];
int frameCanvas[][][];
int selectLayer = 0;
int displayPixels = 16;
int layerNum = 3;
boolean clickState = false;
int selColor = 1;
int selectAlgorithm = 0;


void setup() {

  size(960, 640);
  ellipseMode(CENTER);
  
  canvas = new int[layerNum][displayPixels][displayPixels];
  frameCanvas = new int[layerNum][displayPixels+2][displayPixels+2];

}


void update() {
}


void draw() {
  
  background(0);
  
  // paint by mouse
  if (clickState == true) {
    
    if (mouseX < (displayPixels * pixelSize)) {
      
      int tx = mouseX / pixelSize;
      int ty = mouseY / pixelSize;
      
      canvas[selectLayer][ty][tx] = selColor;
    }
  }

  // add frame to canvas array for image processing
  for(int layer=0; layer < layerNum; layer++) {
    for(int i=0; i<displayPixels+2; i++) {
      for(int j=0; j<displayPixels+2; j++) {
        
        if (i == 0 || j == 0 || i == (displayPixels+1) || j == (displayPixels+1)) {
          frameCanvas[layer][i][j] = 0;
        } else {
          frameCanvas[layer][i][j] = canvas[layer][i-1][j-1];
        }
        
      }
    }
  }

  // draw to canvas by select algorithm
  if (selectAlgorithm == ALGO_ELLIPSE_DOT) {
  
    _drawEllipseDot();

  } else if (selectAlgorithm == ALGO_JOINT_LINE) {
    
    _drawJointLine();
    
  }
  
  stroke(192, 192, 192, 128);
  drawGrid(0, 0, displayPixels*pixelSize, displayPixels*pixelSize, displayPixels, displayPixels);
  
}


void _drawEllipseDot() {
  
  noStroke();
  
  for(int layer=0; layer < layerNum; layer++) {

    for(int i=0; i<displayPixels+2; i++) {

      for(int j=0; j<displayPixels+2; j++) {

        if (frameCanvas[layer][i][j] != 0) {
          if (layer == 0) {
            fill(255, 255, 255);
            ellipse((j+0.5)*pixelSize, (i+0.5)*pixelSize, pixelSize, pixelSize);
          } else {
            fill(240, 240, 240);
            ellipse((j+1)*pixelSize, (i+1)*pixelSize, pixelSize, pixelSize);
          }
        }

      }

    }
  }
  
}


void _drawJointLine() {
  
  stroke(255, 255, 255);
  
  for(int i=0; i<displayPixels; i++) {

    for(int j=0; j<displayPixels; j++) {
      if (frameCanvas[0][i][j] != 0) {

        if (frameCanvas[1][i+1][j+1] != 0) {
          
          line((j+0.5)*pixelSize, (i+0.5)*pixelSize, (j+1.5)*pixelSize, (i+1.5)*pixelSize);
          
        }
        /*
        if (canvas[1][i][j] != 0) {
          
          line((j+0.5)*pixelSize, (i+0.5)*pixelSize, (j+1)*pixelSize, (i+1)*pixelSize);
          
        }*/
        
      }
      
    }
    
  }
 
}


void drawGrid(int x, int y, int w, int h, int squareNumX, int squareNumY) {

  // draw
  // | | | |
  for(int i=1; i<squareNumX; i++) {
      int tx = x + ((w / squareNumX) * i);
      line(tx, y, tx, y + h);
  }

  // draw
  // --------
  // --------
  for(int i=1; i<squareNumY; i++) {
       int ty = y + ((h / squareNumY) * i);
       line(x, ty, x + w, ty);
  }
    
}


void mousePressed() {
  
  if (mouseButton == LEFT) {
    clickState = true;
  }
  
  if (mouseButton == CENTER) {
    selectLayer ^= 1;
  }
  
  if (mouseButton == RIGHT) {

    if (mouseX < (displayPixels * pixelSize)) {
      int tx = mouseX / pixelSize;
      int ty = mouseY / pixelSize;
      
      selColor = canvas[selectLayer][ty][tx];
    }
  }

}


void mouseReleased() {

  clickState = false;

}
