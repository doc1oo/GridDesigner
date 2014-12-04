// GridDesigner
// Grid base graphic design tool by pixel art like drawing method
// doc1oo

import controlP5.*;

ControlP5 cp5;

final int ALGO_ELLIPSE_DOT = 0;
final int ALGO_JOINT_LINE = 1;
final int LAYER_A = 0;
final int LAYER_B = 1;

int pixelSize = 40;
int canvas[][][];
int frameCanvas[][][];
int selectLayer = 0;
int displayPixels = 16;
int layerNum = 3;
int selColor = 1;
int selectAlgorithm = 0;


void setup() {

  size(960, 640);
  ellipseMode(CENTER);
  
  cp5 = new ControlP5(this);

  canvas = new int[layerNum][displayPixels][displayPixels];
  frameCanvas = new int[layerNum][displayPixels+2][displayPixels+2];
  
  // UI
  cp5.addButton("select_Layer_A")
   .setValue(0)
   .setPosition(700,100)
   .setSize(200,40)
   ;
   
  cp5.addButton("select_Layer_B")
   .setValue(100)
   .setPosition(700,150)
   .setSize(200,40)
   ;
  
}


void update() {
}

void draw() {
  
  background(0);

  noStroke();
  fill(128,128,128);
  rect(640, 480, 320, 160);
  fill(255,255,255);
  rect(640+20, 480+20, 120, 120);
  noFill();
  stroke(0,0,0,64);
  rect(640+180, 480+20, 120, 120);
  
  stroke(255,64,64,192);
  strokeWeight(5);
  rect(640 + 10 + (160 * (selColor^1)), 480+10, 140, 140);  
  strokeWeight(1);
  
  // paint by mouse
  if (mousePressed == true) {
    
    if (mouseX < (displayPixels * pixelSize)) {
      
      int tx = mouseX / pixelSize;
      int ty = mouseY / pixelSize;
      
      canvas[selectLayer][ty][tx] = selColor;
    } else {
      
      if (mouseY > 360) {
        
        if (mouseX < (640+160)) {
          
          selColor = 1;
          
        } else {
          
          selColor = 0;
          
        }
        
      }
      
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
  drawGrid(selectLayer*pixelSize/2, selectLayer*pixelSize/2, displayPixels*pixelSize, displayPixels*pixelSize, displayPixels, displayPixels);
  
}


void _drawEllipseDot() {
  
  noStroke();
  
  for(int layer=0; layer < layerNum; layer++) {

    for(int i=1; i<displayPixels+1; i++) {

      int y = i - 1;
      
      for(int j=1; j<displayPixels+1; j++) {

        int x = j - 1;
        
        if (frameCanvas[layer][i][j] != 0) {

          int alpha = 255;
          if (layer != selectLayer) {
            alpha = 127;
          }
          
          fill(255, 255, 255,alpha);
          if (layer == 0) {
            ellipse((x+0.5)*pixelSize, (y+0.5)*pixelSize, pixelSize, pixelSize);
          } else {
            ellipse((x+1)*pixelSize, (y+1)*pixelSize, pixelSize, pixelSize);
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

  // draw vertical lines
  // | | | |
  for(int i=1; i<squareNumX; i++) {
      int tx = x + ((w / squareNumX) * i);
      line(tx, y, tx, y + h);
  }

  // draw horizontal lines
  // --------
  // --------
  for(int i=1; i<squareNumY; i++) {
       int ty = y + ((h / squareNumY) * i);
       line(x, ty, x + w, ty);
  }
    
}


void mousePressed() {
  
  if (mouseButton == CENTER) {
    selectLayer ^= 1;
  }
  
  if (mouseButton == RIGHT) {

    if (mouseX < (displayPixels * pixelSize)) {

      int tx, ty;

      if (selectLayer == LAYER_A) {
      
        tx = mouseX / pixelSize;
        ty = mouseY / pixelSize;
        selColor = canvas[selectLayer][ty][tx];
        
      } else {

        tx = (mouseX - (pixelSize/2)) / pixelSize;
        ty = (mouseY - (pixelSize/2)) / pixelSize;

      }


      selColor = canvas[selectLayer][ty][tx];
      
    }
  }

}


void mouseReleased() {

}



public void controlEvent(ControlEvent theEvent) {
  
  String name = theEvent.getController().getName();

  if (name == "select_Layer_A") {
    
    selectLayer = LAYER_A;
    
  } else if (name == "select_Layer_B") {

    selectLayer = LAYER_B;

  }

}

