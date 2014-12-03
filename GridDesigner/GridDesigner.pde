final int ALGO_ELLIPSE_DOT = 0;
final int ALGO_JOINT_LINE = 1;

int pixelSize = 40;
int canvas[][][];
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
}

void update() {
}

void draw() {
  
  background(0);
  noStroke();
  
  if (clickState == true) {
    if (mouseX < (displayPixels * pixelSize)) {
      int tx = mouseX / pixelSize;
      int ty = mouseY / pixelSize;
      
      canvas[selectLayer][ty][tx] = selColor;
    }
  }
  
  for(int layer=0; layer < layerNum; layer++) {

    for(int i=0; i<displayPixels; i++) {

      for(int j=0; j<displayPixels; j++) {

        if (canvas[layer][i][j] != 0) {
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
