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
int layerNum = 2;
int selectColor = 1;
int selectAlgorithm = 0;
int particleSize = 40;
int editMode = 0;

class LayerInfo {
  
  int posX = 0;
  int posY = 0;
  int pixelSize = 40;
  int canvas[][][];
  int selectLayer = 0;
  int displayPixels = 16;
  int layerNum = 3;
  int selectColor = 1;
  int selectAlgorithm = 0;
  int particleSize = 40;
  int editMode = 0;
  
}

LayerInfo layerInfo[];

Button uiShowAllLayer;
Button uiSelectLayerA;
Button uiSelectLayerB;
Slider uiParticleSize;
Slider uiPosX;
Slider uiPosY;
Slider uiAlgorithm;

void setup() {

  size(960, 640);
  ellipseMode(CENTER);
  
  
  
  cp5 = new ControlP5(this);

  canvas = new int[layerNum][displayPixels][displayPixels];
  frameCanvas = new int[layerNum][displayPixels+2][displayPixels+2];
  
  layerInfo = new LayerInfo[2];
  layerInfo[0] = new LayerInfo();
  layerInfo[1] = new LayerInfo();
  layerInfo[1].posX = 20;
  layerInfo[1].posY = 20;
  
  // UI
  int px = 680;
  uiShowAllLayer = cp5.addButton("show_all_layer")
   .setValue(0)
   .setPosition(px,50)
   .setSize(200,40)
   ;
  uiSelectLayerA = cp5.addButton("select_Layer_A")
   .setValue(0)
   .setPosition(px,100)
   .setSize(200,40)
   ;
   
  uiSelectLayerB = cp5.addButton("select_Layer_B")
   .setValue(0)
   .setPosition(px,150)
   .setSize(200,40)
   ;
   
  uiParticleSize = cp5.addSlider("particle_size")
   .setValue(particleSize)
   .setRange(0,300)
   .setPosition(px,270)
   .setSize(200,20)
   ;
  uiPosX = cp5.addSlider("pos_x")
   .setValue(0)
   .setRange(0,pixelSize)
   .setPosition(px,300)
   .setSize(200,20)
   ;
  
  uiPosY = cp5.addSlider("pos_y")
   .setValue(0)
   .setRange(0,pixelSize)
   .setPosition(px,330)
   .setSize(200,20)
   ;

  uiAlgorithm = cp5.addSlider("algorithm")
   .setValue(0)
   .setRange(0, 1)
   .setPosition(px,360)
   .setSize(200,20)
   ;
  
  selectLayer = 0;
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
  rect(640 + 10 + (160 * (selectColor^1)), 480+10, 140, 140);  
  strokeWeight(1);
  
  LayerInfo layer = layerInfo[selectLayer];
  
  // paint by mouse
  if (mousePressed == true) {
    
    if (mouseButton == LEFT) {
      
      if (mouseX < (displayPixels * pixelSize)) {
        
        int tx = (mouseX - layer.posX) / pixelSize;
        int ty = (mouseY - layer.posY) / pixelSize;
        
        canvas[selectLayer][ty][tx] = selectColor;
      } else {
        
        if (mouseY > 480) {
          
          if (mouseX < (640+160)) {
            
            selectColor = 1;
            
          } else {
            
            selectColor = 0;
            
          }
          
        }
      }
    }
  }

  // add frame to canvas array for image processing
  for(int l=0; l < layerNum; l++) {
    for(int i=0; i<displayPixels+2; i++) {
      for(int j=0; j<displayPixels+2; j++) {
        
        if (i == 0 || j == 0 || i == (displayPixels+1) || j == (displayPixels+1)) {
          frameCanvas[l][i][j] = 0;
        } else {
          frameCanvas[l][i][j] = canvas[l][i-1][j-1];
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
  drawGrid(layer.posX, layer.posY, displayPixels*pixelSize, displayPixels*pixelSize, displayPixels, displayPixels);
  
}


void _drawEllipseDot() {
  
  noStroke();
  
  for(int h=0; h < layerNum; h++) {
    
    LayerInfo l = layerInfo[h];

    for(int i=1; i<displayPixels+1; i++) {

      int y = i - 1;
      
      for(int j=1; j<displayPixels+1; j++) {

        int x = j - 1;
        
        if (frameCanvas[h][i][j] != 0) {
          
          if (editMode == 1) {

            int alpha = 255;
            if (h != selectLayer) {
              alpha = 127;
            }
            
            fill(255, 255, 255,alpha);

          } else {
          
            fill(255, 255, 255);
          
          }
        
          if (h == 0) {
            ellipse((x+0.5)*pixelSize + l.posX, (y+0.5)*pixelSize + l.posY, l.particleSize, l.particleSize);
          } else {
            ellipse((x+1)*pixelSize + l.posX, (y+1)*pixelSize + l.posY, l.particleSize, l.particleSize);
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
          
        } else {
          
            //ellipse((x+1)*pixelSize, (y+1)*pixelSize, 2, 2);
          
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
        selectColor = canvas[selectLayer][ty][tx];
        
      } else {

        tx = (mouseX - (pixelSize/2)) / pixelSize;
        ty = (mouseY - (pixelSize/2)) / pixelSize;

      }


      selectColor = canvas[selectLayer][ty][tx];
      
    }
  }

}


void mouseReleased() {

}



void controlEvent(ControlEvent theEvent) {

  String name = theEvent.getController().getName();
  
  LayerInfo layer = layerInfo[selectLayer];

  if (name == "select_Layer_A") {
    
    selectLayer = LAYER_A;
    editMode = 1;
    _updateGuiByLayerInfo();
    
  } else if (name == "select_Layer_B") {

    selectLayer = LAYER_B;
    editMode = 1;
    _updateGuiByLayerInfo();

  } else if (name == "show_all_layer") {

    editMode = 0;

  } else if (name == "particle_size") {
    layer.particleSize = (int)theEvent.getController().getValue();
    
  } else if (name == "pos_x") {
    layer.posX = (int)theEvent.getController().getValue();
    
  } else if (name == "pos_y") {
    layer.posY = (int)theEvent.getController().getValue();
    
  }

}

void _updateGuiByLayerInfo() {
  
  LayerInfo l = layerInfo[selectLayer];
  
  uiParticleSize.setValue( l.particleSize );
  uiPosX.setValue( l.posX );
  uiPosY.setValue( l.posY );
  
  
}
