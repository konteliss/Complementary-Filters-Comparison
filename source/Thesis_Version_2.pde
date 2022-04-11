/**
 * Show GY521 Data.
 * 
 * Reads the serial port to get x- and y- axis rotational data from an accelerometer,
 * a gyroscope, and comeplementary-filtered combination of the two, and displays the
 * orientation data as it applies to three different colored rectangles.
 * It gives the z-orientation data as given by the gyroscope, but since the accelerometer
 * can't provide z-orientation, we don't use this data.
 * 
 */




int     lf = 10;       //ASCII linefeed
String  inString;      //String for testing serial communication
int     calibrating;
float   datavalprev ;
float   total_time_prev = 0 ;
int     j = 0;
float   dt ;
float   total_time ;
float   x_gyr  ;  //Gyroscope data
float   y_gyr ;
float   z_gyr  ;
float   x_acc  ;  //Accelerometer data
float   y_acc  ;
float   z_acc  ;
float   x_fil  ;  //Filtered from software data
float   y_fil  ;
float   z_fil  ;
float   x_fil_hard_21, x_fil_hard_51, x_fil_hard_11, x_fil_hard_22, x_fil_hard_52, x_fil_hard_12 ;  //Filtered data
float   y_fil_hard_21, y_fil_hard_51, y_fil_hard_11, y_fil_hard_22, y_fil_hard_52, y_fil_hard_12 ; //Filtered data
float   z_fil_hard_21, z_fil_hard_51, z_fil_hard_11, z_fil_hard_22, z_fil_hard_52, z_fil_hard_12 ;  //Filtered data
int     forward_time = 1 ;
int     speed_index = 15;
int paused = 15;


void setup()  {
  
  

    
 // size(640, 360, P3D); 
  size(1800, 900, P3D);
  noStroke();
  colorMode(RGB, 256); 
 

} 

void draw_rect_rainbow() {
  scale(90);
  beginShape(QUADS);

  fill(0, 1, 1); vertex(-1,  1.5,  0.25);
  fill(1, 1, 1); vertex( 1,  1.5,  0.25);
  fill(1, 0, 1); vertex( 1, -1.5,  0.25);
  fill(0, 0, 1); vertex(-1, -1.5,  0.25);

  fill(1, 1, 1); vertex( 1,  1.5,  0.25);
  fill(1, 1, 0); vertex( 1,  1.5, -0.25);
  fill(1, 0, 0); vertex( 1, -1.5, -0.25);
  fill(1, 0, 1); vertex( 1, -1.5,  0.25);

  fill(1, 1, 0); vertex( 1,  1.5, -0.25);
  fill(0, 1, 0); vertex(-1,  1.5, -0.25);
  fill(0, 0, 0); vertex(-1, -1.5, -0.25);
  fill(1, 0, 0); vertex( 1, -1.5, -0.25);

  fill(0, 1, 0); vertex(-1,  1.5, -0.25);
  fill(0, 1, 1); vertex(-1,  1.5,  0.25);
  fill(0, 0, 1); vertex(-1, -1.5,  0.25);
  fill(0, 0, 0); vertex(-1, -1.5, -0.25);

  fill(0, 1, 0); vertex(-1,  1.5, -0.25);
  fill(1, 1, 0); vertex( 1,  1.5, -0.25);
  fill(1, 1, 1); vertex( 1,  1.5,  0.25);
  fill(0, 1, 1); vertex(-1,  1.5,  0.25);

  fill(0, 0, 0); vertex(-1, -1.5, -0.25);
  fill(1, 0, 0); vertex( 1, -1.5, -0.25);
  fill(1, 0, 1); vertex( 1, -1.5,  0.25);
  fill(0, 0, 1); vertex(-1, -1.5,  0.25);

  endShape();
  
  
}

void draw_rect(int r, int g, int b) {
  scale(80);
  beginShape(QUADS);
  
  fill(r, g, b);
  vertex(-1,  1.5,  0.25);
  vertex( 1,  1.5,  0.25);
  vertex( 1, -1.5,  0.25);
  vertex(-1, -1.5,  0.25);

  vertex( 1,  1.5,  0.25);
  vertex( 1,  1.5, -0.25);
  vertex( 1, -1.5, -0.25);
  vertex( 1, -1.5,  0.25);

  vertex( 1,  1.5, -0.25);
  vertex(-1,  1.5, -0.25);
  vertex(-1, -1.5, -0.25);
  vertex( 1, -1.5, -0.25);

  vertex(-1,  1.5, -0.25);
  vertex(-1,  1.5,  0.25);
  vertex(-1, -1.5,  0.25);
  vertex(-1, -1.5, -0.25);

  vertex(-1,  1.5, -0.25);
  vertex( 1,  1.5, -0.25);
  vertex( 1,  1.5,  0.25);
  vertex(-1,  1.5,  0.25);

  vertex(-1, -1.5, -0.25);
  vertex( 1, -1.5, -0.25);
  vertex( 1, -1.5,  0.25);
  vertex(-1, -1.5,  0.25);

  endShape();
  
  
}


void draw()  {
  background(10);
  lights();
  
 
  
  String[] lines = loadStrings("TXT2.txt");
  
  
  
  inString = lines[j] ;
  //println(j);
  //println(inString);
  
  try {
    // Parse the data
    String[] dataStrings = split(inString, '#');
    for (int i = 0; i < dataStrings.length; i++) {
      String type = dataStrings[i].substring(0, 4);
      String dataval = dataStrings[i].substring(4);
    if (type.equals("DEL:")) {
      
        total_time = float(dataval);
        dt =total_time -  total_time_prev ;
        total_time_prev = total_time;
        
        
      } else if (type.equals("ACC:")) {
        String data[] = split(dataval, ',');
        x_acc = float(data[0]);
        y_acc = float(data[1]);
        z_acc = float(data[2]);
       /*
        print("Acc:");
        print(x_acc);
        print(",");
        print(y_acc);
        print(",");
        println(z_acc);
       */ 
      } else if (type.equals("GYR:")) {
        String data[] = split(dataval, ',');
        x_gyr = float(data[0]);
        y_gyr = float(data[1]);
        z_gyr = float(data[2]);
        

      } else if (type.equals("FIS:")) {
        String data[] = split(dataval, ',');
        x_fil = float(data[0]);
        y_fil = float(data[1]);
        z_fil = float(data[2]);
        
        
      } else if (type.equals("H21:")) {
        String data[] = split(dataval, ',');
        x_fil_hard_21 = float(data[0]);
        y_fil_hard_21 = float(data[1]);
        z_fil_hard_21 = float(data[2]);
        
      } else if (type.equals("H51:")) {
        String data[] = split(dataval, ',');
        x_fil_hard_51 = float(data[0]);
        y_fil_hard_51 = float(data[1]);
        z_fil_hard_51 = float(data[2]);
        
      } else if (type.equals("H11:")) {
        String data[] = split(dataval, ',');
        x_fil_hard_11 = float(data[0]);
        y_fil_hard_11 = float(data[1]);
        z_fil_hard_11 = float(data[2]);
        
      } else if (type.equals("H22:")) {
        String data[] = split(dataval, ',');
        x_fil_hard_22 = float(data[0]);
        y_fil_hard_22 = float(data[1]);
        z_fil_hard_22 = float(data[2]);
        
      } else if (type.equals("H52:")) {
        String data[] = split(dataval, ',');
        x_fil_hard_52 = float(data[0]);
        y_fil_hard_52 = float(data[1]);
        z_fil_hard_52 = float(data[2]);
        
      } else if (type.equals("H12:")) {
        String data[] = split(dataval, ',');
        x_fil_hard_12 = float(data[0]);
        y_fil_hard_12 = float(data[1]);
        z_fil_hard_12 = float(data[2]);
        
      }
      
      datavalprev = float(dataval) ;
     
    }
  } catch (Exception e) {
      println("Caught Exception");
  }
  
  
  
 j = j + abs( speed_index+ paused) *  forward_time / 2 ;  // The number in this line changes the playback speed. Default value is 3
 
 
 if(j >= lines.length){ j = speed_index;} // Makes the video repeat after it finishes
 if(j <= speed_index - 1  ){j = lines.length - 1;}
 
 

      
  // Tweak the view of the rectangles
  
  int x_rotation = 90;
  
  //Show gyro data
  pushMatrix(); 
  translate(width/7, height/2, -50); 
  rotateX(radians(-x_gyr - x_rotation));
  rotateY(radians(-y_gyr));
  draw_rect(249, 250, 50);
  
  popMatrix(); 

  //Show accel data
  pushMatrix();
  translate(2*width/7, height/2, -50);
  rotateX(radians(-x_acc - x_rotation));
  rotateY(radians(-y_acc));
  draw_rect(56, 140, 206);
  popMatrix();
  
  //Show combined from software data
  pushMatrix();
  translate(3*width/7, (height/2), -50);
  rotateX(radians(-x_fil - x_rotation));
  rotateY(radians(-y_fil));
  draw_rect(93, 175, 83);
  popMatrix();
  
    //Show combined data Volume 2 !!!!! 
  //Show combined data
  
  
  //H21
  pushMatrix();
  translate(4*width/7, (height/2) - 200, -50);
  rotateX(radians(-x_fil_hard_21 - x_rotation));
  rotateY(radians(-y_fil_hard_21));
  draw_rect(93, 175, 83);
  popMatrix();
  
    //H51
  pushMatrix();
  translate(5*width/7, (height/2) - 200, -50);
  rotateX(radians(-x_fil_hard_51 - x_rotation));
  rotateY(radians(-y_fil_hard_51));
  draw_rect(93, 175, 83);
  popMatrix();
  
    //H11
  pushMatrix();
  translate(6*width/7, (height/2) - 200, -50);
  rotateX(radians(-x_fil_hard_11 - x_rotation));
  rotateY(radians(-y_fil_hard_11));
  draw_rect(93, 175, 83);
  popMatrix();
  
    //H22
  pushMatrix();
  translate(4*width/7, (height/2) + 200, -50);
  rotateX(radians(-x_fil_hard_22 - x_rotation));
  rotateY(radians(-y_fil_hard_22));
  draw_rect(93, 175, 83);
  popMatrix();
  
    //H52
  pushMatrix();
  translate(5*width/7, (height/2) + 200, -50);
  rotateX(radians(-x_fil_hard_52 - x_rotation));
  rotateY(radians(-y_fil_hard_52));
  draw_rect(93, 175, 83);
  popMatrix();
  
    //H12
  pushMatrix();
  translate(6*width/7, (height/2) + 200, -50);
  rotateX(radians(-x_fil_hard_12 - x_rotation));
  rotateY(radians(-y_fil_hard_12));
  draw_rect(93, 175, 83);
  popMatrix();
 
  textSize(24);
  String accStr = "(" + (int) x_acc + ", " + (int) y_acc + ")";
  String gyrStr = "(" + (int) x_gyr + ", " + (int) y_gyr + ")";
  String filStr = "(" + (int) x_fil + ", " + (int) y_fil + ")";
  String fil_hard_21_Str = "(" + (int) x_fil_hard_21 + ", " + (int) y_fil_hard_21 + ")";
  String fil_hard_51_Str = "(" + (int) x_fil_hard_51 + ", " + (int) y_fil_hard_51 + ")";
  String fil_hard_11_Str = "(" + (int) x_fil_hard_11 + ", " + (int) y_fil_hard_11 + ")";
  String fil_hard_22_Str = "(" + (int) x_fil_hard_22 + ", " + (int) y_fil_hard_22 + ")";
  String fil_hard_52_Str = "(" + (int) x_fil_hard_52 + ", " + (int) y_fil_hard_52 + ")";
  String fil_hard_12_Str = "(" + (int) x_fil_hard_12 + ", " + (int) y_fil_hard_12 + ")";
  String fildt     =  String.valueOf(dt) ; 
  String total_timeStr     = "(" +  total_time + " )" ;
  String controls = ("Press P for Play/Pause , +/- for speed control");
  
  
  fill(150, 60, 60);
  text(controls,10, 880);

  fill(249, 250, 50);
  text("Gyroscope", (int) width/7.0 - 60, 250);
  text(gyrStr, (int) (width/7.0) - 40, 275);

  fill(56, 140, 206);
  text("Accelerometer", (int) 2*width/7.0 - 60, 250);
  text(accStr, (int) 2*width/7.0 - 30, 275); 
  
  fill(83, 175, 93);
  text("Software Combination", (int) (3.0*width/7.0) - 100, 250);
  text(filStr, (int) (3.0*width/7.0) - 20, 275);
  
 // fill(56, 110, 206);
 // text("Time interval", (int) width/7.0 - 50, 100);
  //text(fildt, (int) (width/7.0) - 30, 125);
  

  
  
  total_time = total_time + dt ;
  
  fill(128, 0, 128);
  text("Total virtual time elapsed", (int) width/7.0 - 50, 150);
  text(total_timeStr, (int) (width/7.0) - 30, 175);

  fill(83, 170, 93);
  text("1st Order τ=2", (int) (4.0*width/7.0 - 115) , height/2 -  350);
  text(fil_hard_21_Str, (int) (4.0*width/7.0) - 50   ,  height/2 - 325);
  
  fill(83, 170, 93);
  text("1st Order τ=5", (int) (5.0*width/7.0) -115, height/2 - 350);
  text(fil_hard_51_Str, (int) (5.0*width/7.0) -50 ,  height/2 - 325 );
  
  fill(83, 170, 93);
  text("1st Order τ=10", (int) (6.0*width/7.0) - 115, height/2 -350);
  text(fil_hard_11_Str, (int) (6.0*width/7.0) - 50  ,  height/2 - 325);
  
  fill(83, 230, 93);
  text("2nd Order fc=79mHz", (int) (4.0*width/7.0) -125 , height/2 + 25);
  text(fil_hard_22_Str, (int) (4.0*width/7.0) - 50   ,  height/2 + 55);
  
  fill(83, 230, 93);
  text("2nd Order fc=31.8mHz", (int) (5.0*width/7.0) - 115, height/2 + 25);
  text(fil_hard_52_Str, (int) (5.0*width/7.0) - 50  ,  height/2 + 55);
  
  fill(83, 230, 93);
  text("2nd Order fc=15.9mHz", (int) (6.0*width/7.0) - 70, height/2 + 25);
  text(fil_hard_12_Str, (int) (6.0*width/7.0) - 50  , height/2 + 55);
  
  }
  
 public void keyPressed() {
   
   // this function controls the speed and play/pause features

    if ( key == 'p' || key =='P' || key==' ' ) {

    paused = paused * (-1) ;

  }
  
    else if( key == 'b' || key =='B') {
    forward_time = forward_time * (-1);
    
  }
    else if( key == '+') {
    speed_index  = speed_index +3 ;
    paused = speed_index;
    if ( speed_index > 50) { speed_index = 50;
    paused = speed_index;
  }
    }
    else if( key == '-') {
    speed_index  = speed_index  -  3 ;
    paused = speed_index;
    if ( speed_index < 1 ) { speed_index = 1;
    paused = speed_index;
    
  }
}

    }
     
