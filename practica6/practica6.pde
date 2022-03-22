import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture cam, cam2;
OpenCV opencv, faceCanny, faceThreshold, faceBlur, faceRed;

int dimension;
int pointillize = 16;

int mode = 0;
int colorMode = 0;

boolean help = true;

String colorStr = "none";

void setup() {
  size(640, 480);
  cam = new Capture(this, 640/2, 480/2);
  cam2 = new Capture(this, 640/2, 480/2);
  
  faceCanny = new OpenCV(this, 640/2, 480/2);
  faceThreshold = new OpenCV(this, 640/2, 480/2);   
  faceBlur = new OpenCV(this, 640/2, 480/2); 
  faceRed = new OpenCV(this, 640/2, 480/2); 
  
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  cam.start();
}

void draw() {
  scale(2);
  opencv.loadImage(cam);

  noTint();
  image(cam, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  
  controles(); 
  
  if(help){
    help();
    
  }else{
    
    for (int i = 0; i < faces.length; i++) {
      
      switch(mode){
        case 0:
          if(colorMode == 1) tint(255,0,0);
          if(colorMode == 2) tint(0,255,0);
          if(colorMode == 3) tint(0,0,255);
          image(cam, 0, 0 );
          rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
          fill(255);
          text("Filter: Face detection", 10,15);
          text("Color: "+colorStr, 10,25);
          text("Help 'h'", 10, 230);          
          break;
       
       case 1: 
          canny(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
          break;
          
       case 2:
          threshold(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
          break;
          
       case 3: 
          blur(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
          break;    
      }
     
    }
  }
}

void canny(int face_X, int face_Y, int face_W, int face_H){
    faceCanny.loadImage(cam);
    faceCanny.setROI(face_X, face_Y, face_W, face_H);    
    faceCanny.findCannyEdges(20,75);
    if(colorMode == 1) tint(255,0,0);
    if(colorMode == 2) tint(0,255,0);
    if(colorMode == 3) tint(0,0,255);
    image(faceCanny.getOutput(), 0, 0);
    image(faceCanny.getSnapshot(), width, height);  
    fill(255);
    text("Canny", 10,15);
    text("Color: "+colorStr, 10,25);
    text("Help 'h'", 10, 230);
}

void threshold(int face_X, int face_Y, int face_W, int face_H){
    faceThreshold.loadImage(cam);
    faceThreshold.setROI(face_X, face_Y, face_W, face_H);    
    faceThreshold.threshold(80);
    if(colorMode == 1) tint(255,0,0);
    if(colorMode == 2) tint(0,255,0);
    if(colorMode == 3) tint(0,0,255);
    image(faceThreshold.getOutput(), 0, 0);
    image(faceThreshold.getSnapshot(), width, height); 
    fill(255);
    text("Threshold", 10,15);
    text("Color: "+colorStr, 10,25);
    text("Help 'h'", 10, 230);
}

void blur(int face_X, int face_Y, int face_W, int face_H){
    faceBlur.loadImage(cam);
    faceBlur.setROI(face_X, face_Y, face_W, face_H);   
    faceBlur.blur(12); 
    if(colorMode == 1) tint(255,0,0);
    if(colorMode == 2) tint(0,255,0);
    if(colorMode == 3) tint(0,0,255);
    
    image(faceBlur.getOutput(), 0, 0);
    image(faceBlur.getSnapshot(), width, height);    
    fill(255);
    text("Blur", 10,15);
    text("Color: "+colorStr, 10,25);
    text("Help 'h'", 10, 230);
}


void captureEvent(Capture c) {
  c.read();
}


void controles(){
   switch(key){
      case 'r':
           colorMode = 1;
           colorStr = "red";
           break;
       
      case 'g':
          colorMode = 2;
          colorStr = "green";
          break;
       
      case 'b':
          colorMode = 3;
          colorStr = "blue";
          break;
       
      case 'n':
          colorMode = 0;
          colorStr = "none";
          break;
          
      case 'h':
          help = true;
          break;
          
      case 'q':
          help = false;
          break;
      
      case '0':
        mode = 0;
        break;
          
      case '1':
        mode = 1;
        break;
      
      case '2':
        mode = 2;
        break;
        
      case '3':
        mode = 3;
        break;
  }  

}

void help(){
      fill(255);
      stroke(0);
      strokeWeight(1);
      rect(30,20,250,200);
      fill(0);       
      textSize(16);
      text("Controles", 120, 40);
      
      
      textSize(12);
      text("Cambiar de filtro ", 40, 65);
      textSize(10);
      text("Face detection '0'", 40, 80);
      text("Canny '1'", 40, 95);
      text("Threshold '2'", 40, 110);
      text("Blur '3'", 40, 125);
      
      textSize(12);
      text("Cambiar el color ", 40, 145);
      textSize(10);
      text("Red 'r'", 40, 160);
      text("Green 'g'", 40, 175);
      text("Blue 'b'", 40, 190);
      text("None 'n'", 40, 205);
      
      
      text("Salir de ayuda 'q'", 200, 210);      
      

}
    


   
