import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import java.util.HashMap; 
import java.util.Map; 
import javax.sound.midi.Receiver; 
import javax.sound.midi.MidiMessage; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class black_amoeba_part2_0318_01 extends PApplet {

/**
 * ControlP5 Controlframe
 *
 * this example shows you how to create separate window to
 * display and use controllers with  processing 3
 *
 * by Andreas Schlegel, 2016
 * www.sojamo.de/libraries/controlp5
 *
 */
//\uc62c \uc88b\uc740\ub370








ControlFrame cf;

float speed;
float pos;
float c0, c1, c2, c3;
boolean auto;

int rows, cols;
int cellSizeW, cellSizeH;
int bri; //\ud3ec\uc778\ud2b8\uc758 \ubc1d\uae30
int cellNum;

int[] nullCell = {1,2,3,4,5,6};;

Serial myPort1, myPort2, myPort3, myPort4, myPort5, myPort6;



public void settings() {
	size(390, 396);
}

public void setup() {


	//\uc804\uc790\uc11d \ubc30\uc5f4 \uac1c\uc218 : \uac00\ub85c 30 x \uc138\ub85c 22
	cellSizeW = 13;
	cellSizeH = 18;
	cellNum = 1;

	rows = width / cellSizeW;
	cols = height / cellSizeH;

	printArray(Serial.list());
	String portName = Serial.list()[0];
	println("select port: "+portName);
	println("---------------------------------------------------------------------------");

	myPort1 = new Serial(this, portName, 250000);


	cf = new ControlFrame(this, 400, 800, "Controls");
	surface.setLocation(802, 0);
	noStroke();
}

public void draw() {
	
	background(0);

	for (int i = 0; i < rows; i++) {

		for (int j = 0; j < cols; j++) {
			int x = j * cellSizeW;
			int y = i * cellSizeH;

		/*
        int loc = (this.width + x - 1) + y*this.width; // Reversing x to mirror the image
        //int loc = (rgbImage.width - x - 1) + y*rgbImage.width; // Reversing x to mirror the image
        color c = this.pixels[loc+40];

        bri = (int)brightness(c);
        */
    

    for(int n=0 ; n < nullCell.length ; n++){

    	//println("nullCell= " + nullCell[n]);

        if(cellNum == nullCell[n]){
        fill(100);
        //fill(fishImage.pixels[loc]);
        noStroke();
        rect(x - cellSizeW, y - cellSizeH, cellSizeW-1, cellSizeH-1);
    	}
    	else{
        //fill(fishImage.pixels[loc]);
        fill(20);
        noStroke();
        rect(x - cellSizeW, y - cellSizeH, cellSizeW-1, cellSizeH-1);	
    }
}


		/*
		//\uc544\ub450\uc774\ub178 \uc804\uc1a1
		myPort1.write( "$LED" + "," + str(cellNum) + "," + str(bri) + "\n");
		print("cellNum:"+cellNum + ", ");
		println("bri:"+ bri);
		*/
		cellNum++;
		println("cellNum:"+cellNum);
	}

}
cellNum=1;


  // println("rows=" + rows);
  // println("cols=" + cols);
  // println(" ");

// println("nullCell= " + nullCell.length);
} 
class ControlFrame extends PApplet {


  Map<String, String> midimapper = new HashMap<String, String>();

  int cols = 21;
  int rows = 4;
  int[] layoutX = new int[cols]; // layout grid for NanoKONTROL2
  int[] layoutY = new int[rows]; // layout grid for NanoKONTROL2
  int sliderVal;
  int turnNum=0;
  int moniterY = 210;

  final int HANDLE_NB = 8;
  HandleList handles = new HandleList(false);



  float xOffset = 0.0f;
  float yOffset = 0.0f;
  


  int[] KNOB = new int[10];
  int slider1, slider2, slider3, slider4, slider5, slider6, slider7, slider8;
  boolean rec=false;
  boolean play=false;
  boolean stop=false;


  byte[] MIDImsg = new byte[100];
  ;

  String[] sliders = new String[7];
  String[] knobs = new String[7];
  String[] bts = new String[34];

  int cSize;
  boolean labelVisibility = true;

  boolean trackP, trackN;


  int w, h;
  PApplet parent;
  ControlP5 cp5;


  // int size1 = 50;
  // int size2 = 60;
  // int size3 = 70;
  // int size4 = 80;
  // int size5 = 80;
  // int size6 = 80;
  // int size7 = 80;
  // int size8 = 80;

  int[] size = new int[100];



  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();
    parent = _parent;
    w=800;
    h=260;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    // size(w, h);
    size( 800, 1010 );
    w = 800;
    h = 260;
    cSize = PApplet.parseInt(w/(cols+1)/2);
  }

  public void setup() {
    smooth();
    surface.setLocation(0, 0);
    background(100);






    //\ub3d9\uadf8\ub77c\ubbf8 \ub9cc\ub4e4\uae30 
    for (int i = 0; i < HANDLE_NB; i++)
    {

      //turnNum++;
      //int size = int(random(15, 30));

      handles.add(new Handle( 
        //X\uc704\uce58
        size[i] + random(width - 2 * size[i]), 
        //Y\uc704\uce58 
        size[i] + random((height - 2 * size[i])-moniterY),
        //\ud06c\uae30
        size[i], size[i] / 5, 
        //\uc0c9\uc0c1
        color(255,0,0), color(0,255,0), 
        color(0,0,255), color(255,255,0)
        ));

      turnNum = i;
     //println("turnNum= " + turnNum);
   }

    //turnNum = 0;


    /*
   give each layout colomn and row a absolute x and y
     in order to easily place controller in a layout grid
     */
     for (int x = 0; x < layoutX.length; x++) {
      for (int y = 0; y < layoutY.length; y++) {
        layoutX[x] = PApplet.parseInt(w/(cols+1) * (x+1));
        layoutY[y] = PApplet.parseInt(h/(rows+1) * (y+1));
      }
    }






    sliders[0] = "slider1";










    cp5 = new ControlP5( this );
    cp5.setPosition(-cSize/2, (-cSize/2) - 30); // serves like rectmode CENTER
    // I'd like to align all the labels at once to the center, but don't know how
    //cp5.getAll().alignLabel(CENTER);

    cp5.begin();


    // add controllers according to those on the nanoKONTROL2

    int counter = 1; // in order to number the controller independently from their location

    for (int i = 6; i < 21; i += 2) {
      cp5.addKnob("knob"+(counter))
      .setPosition(layoutX[i], layoutY[0])
      .setRadius(cSize/2)
      .setLabelVisible(labelVisibility)
        //.setValue(100);
        ;
        counter++;
      }
      counter = 1;
      for (int i = 6; i < 21; i += 2) {
        cp5.addSlider("slider"+(counter))
        .setPosition(layoutX[i], layoutY[1])
        .setSize(cSize, layoutY[3]-layoutY[1])
        .setRange(0, 255)
        .setLabelVisible(labelVisibility)
        ;
        counter++;
      }

      counter = 1;
      for (int i = 5; i < 20; i += 2) {
        cp5.addBang("s"+(counter))
        .setPosition(layoutX[i], layoutY[1])
        .setSize(cSize, cSize)
        .setLabelVisible(labelVisibility)
        ;
        counter++;
      }
      counter = 1;
      for (int i = 5; i < 20; i += 2) {
        cp5.addBang("m"+(counter))
        .setPosition(layoutX[i], layoutY[2])
        .setSize(cSize, cSize)
        .setLabelVisible(labelVisibility)
        ;
        counter++;
      }
      counter = 1;
      for (int i = 5; i < 20; i += 2) {
        cp5.addBang("r"+(counter))
        .setPosition(layoutX[i], layoutY[3])
        .setSize(cSize, cSize)
        .setLabelVisible(labelVisibility)
        ;
        counter++;
      }

      cp5.addBang("trackP")
      .setPosition(layoutX[0], layoutY[1])
      .setSize(cSize, cSize)
      .setLabelVisible(labelVisibility)
      ;
      cp5.addBang("trackN")
      .setPosition(layoutX[1], layoutY[1])
      .setSize(cSize, cSize)
      .setLabelVisible(labelVisibility)
      ;

      cp5.addBang("cycle")
      .setPosition(layoutX[0], layoutY[2])
      .setSize(cSize, cSize)
      .setLabelVisible(labelVisibility)
      ;

      cp5.addBang("set")
      .setPosition(layoutX[2], layoutY[2])
      .setSize(cSize, cSize)
      .setLabelVisible(labelVisibility)
      ;
      cp5.addBang("markerP")
      .setPosition(layoutX[3], layoutY[2])
      .setSize(cSize, cSize)
      .setLabelVisible(labelVisibility)
      ;
      cp5.addBang("markerN")
      .setPosition(layoutX[4], layoutY[2])
      .setSize(cSize, cSize)
      .setLabelVisible(labelVisibility)
      ;

      cp5.addBang("rewind")
      .setPosition(layoutX[0], layoutY[3])
      .setSize(cSize, cSize)
      .setLabelVisible(labelVisibility)
      ;
      cp5.addBang("ff")
      .setPosition(layoutX[1], layoutY[3])
      .setSize(cSize, cSize)
      .setLabelVisible(labelVisibility)
      ;
      cp5.addBang("stop!")
      // giving name "stop" (without the !) here would cause the program to call
      // a method which stops the ControlListener I guess or something that
      // results in the cp5 not responding to anything anymore. the sketch
      // however doesn't crash. a bug??
      .setPosition(layoutX[2], layoutY[3])
      .setSize(cSize, cSize)
      .setLabelVisible(labelVisibility)
      ;
      cp5.addBang("play")
      .setPosition(layoutX[3], layoutY[3])
      .setSize(cSize, cSize)
      .setLabelVisible(labelVisibility)
      ;
      cp5.addBang("rec")
      .setPosition(layoutX[4], layoutY[3])
      .setSize(cSize, cSize)
      .setLabelVisible(labelVisibility)
      ;

      cp5.end();


    // all the midi inputs are mapped to controllers
    final String device = "nanoKONTROL2 1 SLIDER/KNOB";

    midimapper.clear();

    for (int i = 0; i < 8; i++) {
      midimapper.put( ref( device, i + 16 ), "knob"+(i+1) );
    }
    for (int i = 0; i < 8; i++) {
      midimapper.put( ref( device, i ), "slider"+(i+1) );
    }

    for (int i = 0; i < 8; i++) {
      midimapper.put( ref( device, i + 32 ), "s"+(i+1) );
    }
    for (int i = 0; i < 8; i++) {
      midimapper.put( ref( device, i + 48 ), "m"+(i+1) );
    }
    for (int i = 0; i < 8; i++) {
      midimapper.put( ref( device, i + 64), "r"+(i+1) );
    }

    midimapper.put( ref( device, 58 ), "trackP" );
    midimapper.put( ref( device, 59 ), "trackN" );

    midimapper.put( ref( device, 46 ), "cycle" );
    midimapper.put( ref( device, 60 ), "set" );
    midimapper.put( ref( device, 61 ), "markerP" );
    midimapper.put( ref( device, 62 ), "markerN" );

    midimapper.put( ref( device, 43 ), "rewind" );
    midimapper.put( ref( device, 44 ), "ff" );
    midimapper.put( ref( device, 42 ), "stop!" );
    midimapper.put( ref( device, 41 ), "play" );
    midimapper.put( ref( device, 45 ), "rec" );


    boolean DEBUG = false;





    if (DEBUG) {
      new MidiSimple( device );
    } else {
      new MidiSimple( device, new Receiver() {

        @Override public void send( MidiMessage msg, long timeStamp ) {

          byte[] b = msg.getMessage();
          MIDImsg = msg.getMessage();



          if ( b[ 0 ] != -48 ) {

            Object index = ( midimapper.get( ref( device, b[ 1 ] ) ) );

            if ( index != null ) {

              Controller c = cp5.getController(index.toString());
              if (c instanceof Slider ) {
                float min = c.getMin();
                float max = c.getMax();
                c.setValue(map(b[ 2 ], 0, 127, 0, 256) );

                // println("b[1]= " + b[1]);


                //? \u8e30\u3164??\u80db??\u6e21??\u572d? \u8e30????\ud049??, index.toString ??? \u8e30\u3164??\u80db??\u6e21??\u572d? \u91ab\u3164??\u55ae??\u6e21??\ud049? ??\u6e21??\u68cb???\u6e21??\u68cb???\u6e21??\u7678???\u6e21??\u8ab2? ??\u6e21??\u8872???\u6e21??\u68cb???\u6e21??\u548e?
                sliderVal = (int)map(b[ 2 ], 0, 127, min, max);
              } else if ( c instanceof Knob ) {
                float min = c.getMin();
                float max = c.getMax();
                c.setValue(map(b[ 2 ], 0, 127, min, max) );
              } else if ( c instanceof Button ) {
                if ( b[ 2 ] > 0 ) {
                  c.setValue( c.getValue( ) );
                  c.setColorBackground( 0xff08a2cf );
                } else {
                  c.setColorBackground( 0xff003652 );
                }
              } else if ( c instanceof Bang ) {
                if ( b[ 2 ] > 0 ) {
                  c.setValue( b[ 2 ] );
                  c.setColorForeground( 0xff08a2cf );
                } else {
                  c.setValue(b[ 2 ]);
                  c.setColorForeground( 0xff00698c );
                }
              } else if ( c instanceof Toggle ) {
                if ( b[ 2 ] > 0 ) {
                  ( ( Toggle ) c ).toggle( );
                }
              }
            }

            // println("index= " + index.toString());
            println("b[1]= " + MIDImsg[1]);
            println("b[2]= " + MIDImsg[2]);
            // println("timeStamp= " + timeStamp);




            //slider
            if ( b[1] == 0) {
              slider1 = (int)map(b[ 2 ], 0, 127, 0, 255);
              println("slider1");
            }
            if ( b[1] == 1) {
              slider2 = (int)map(b[ 2 ], 0, 127, 0, 255);
              println("slider2");
            }
            if ( b[1] == 2) {
              slider3 = (int)map(b[ 2 ], 0, 127, 0, 255);
              println("slider3");
            }
            if ( b[1] == 3) {
              slider4 = (int)map(b[ 2 ], 0, 127, 0, 255);
              println("slider4");
            }
            if ( b[1] == 4) {
              slider5 = (int)map(b[ 2 ], 0, 127, 0, 255);
              println("slider5");
            }
            if ( b[1] == 5) {
              slider6 = (int)map(b[ 2 ], 0, 127, 0, 255);
              println("slider6");
            }
            if ( b[1] == 6) {
              slider7 = (int)map(b[ 2 ], 0, 127, 0, 255);
              println("slider7");
            }
            if ( b[1] == 7) {
              slider8 = (int)map(b[ 2 ], 0, 127, 0, 255);
              println("slider8");
            }



            //knob
            if ( b[1] == 16) {
              KNOB[0] = b[2];
              size[0] = b[2];
              println("knob1");
            }
            if ( b[1] == 17) {
              KNOB[1] = b[2];
              size[1] = b[2];
              println("knob2");
            }
            if ( b[1] == 18) {
             KNOB[2] = b[2];
             size[2] = b[2];
             println("knob3");
           }
           if ( b[1] == 19) {
             KNOB[3] = b[2];
             size[3] = b[2];
             println("knob4");
           }
           if ( b[1] == 20) {
             KNOB[4] = b[2];
             size[4] = b[2];
             println("knob5");
           }
           if ( b[1] == 21) {
             KNOB[5] = b[2];
             size[5] = b[2];
             println("knob6");
           }
           if ( b[1] == 22) {
             KNOB[6] = b[2];
             size[6] = b[2];
             println("knob7");
           }
           if ( b[1] == 23) {
             KNOB[7] = b[2];
             size[7] = b[2];
             println("knob8");
           }



            //button
            if ( b[1] == 42) {

              exit();
              println("Stop");
            }
            if ( b[1] == 41) {
              println("Play");
            }
            if ( b[1] == 45) {
              println("All REC");
            }





            if ( b[1] == 64) {
              println("Point 1 REC");
            }
            if ( b[1] == 65) {
              println("Point 2 REC");
            }
            if ( b[1] == 66) {
              println("Point 3 REC");
            }
            if ( b[1] == 67) {
              println("Point 4 REC");
            }
            if ( b[1] == 68) {
              println("Point 5 REC");
            }
            if ( b[1] == 69) {
              println("Point 6 REC");
            }
            if ( b[1] == 70) {
              println("Point 7 REC");
            }
            if ( b[1] == 71) {
              println("Point 8 REC");
            }
          }
        }

        @Override public void close( ) {
        }
      }
      );
}
}


public String ref(String theDevice, int theIndex) {
  return theDevice+"-"+theIndex;
}

public void draw() {
  background(100 );

    //\uf9cf????\u548e? \uf9cf?????????\u6e21??\ud639? ?
    pushMatrix();
    translate(0, moniterY);
    noStroke();
    fill(0);
    rect(0, 0, 800, 800);


    handles.update();

    popMatrix();
  }
}
/*
PhiLhoSoft's Processing sketches.
 http://processing.org/
 
 by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr & http://PhiLho.deviantART.com
 */
/* File/Project history:
 2.00.000 -- 2012/11/13 (PL) -- Separate Handle and HandleList, standard method names.
 1.01.000 -- 2010/01/29 (PL) -- Update to better code, added HandleList.
 1.00.000 -- 2008/04/29 (PL) -- Creation.
 */
/* Copyright notice: For details, see the following file:
 http://Phi.Lho.free.fr/softwares/PhiLhoSoft/PhiLhoSoftLicense.txt
 This program is distributed under the zlib/libpng license.
 Copyright (c) 2008-2012 Philippe Lhoste / PhiLhoSoft
 */

/**
 * A circle that can be dragged with the mouse.
 */
 class Handle
 {
  // Lazy (Processing) class: leave direct access to parameters... Avoids having lot of accessors.
  //float m_x, m_y, m_x2, m_y2; // Position of handle
  float[] m_x = new float[10];
  float[] m_y = new float[10]; // Diameter of handle
  int m_lineWidth, m_lineWidth2;
  int num=0;
  int m_colorLine;
  int m_colorFill;
  //color m_colorHover;
  int[] m_colorHover = new int[10];

  int m_colorDrag;



//\ud3ec\uc778\ud130 \uceec\ub7ec
int defaultColor;
int mouseOnColor;
int dragColor;
int[] magPower = new int[7];



  //m_size[] = new int [8];
  int[] m_size = new int[10];
  int[] Psize = new int[10];

  int isD;

  //private boolean m_colorHover;

  boolean[] m_bDragged = new boolean[10];
  boolean[] m_bIsHovered = new boolean[10];


  private float m_clickDX, m_clickDY;
  private int m_knobSize;
  
  


  /**
   * Simple constructor with hopefully sensible defaults.
   */


  // Handle(float x, float y)
  // {
  //   this(x, y, 5, 1, #000000, #FFFFFF, #FFFF00, #FF8800);
  // }




  /**
   * Full constructor.
   */

  //CFturn = cf.turn;

  Handle(float x, float y, int size, int lineWidth, 
    int colorLine, int colorFill, int colorHover, int colorDrag
    )
  {

    //if (num < cf.HANDLE_NB)
    //{
      m_x[cf.turnNum] = x;
      m_y[cf.turnNum] = y;
      m_size[cf.turnNum] = size;
      m_lineWidth = lineWidth;
      m_colorLine = colorLine;
      m_colorFill = colorFill;
      m_colorHover[cf.turnNum] = colorHover;
      m_colorDrag = colorDrag;

      //println("HDtern= " + cf.turnNum );
    //  }
    //  num = num+1;
  }


  /**
   * Updates the state of the handle depending on the mouse position.
   *
   * @param bAlreadyDragging  if true, a dragging is already in effect
   */
   public void update(boolean bAlreadyDragging)
   {
     for (int i=0; i < cf.HANDLE_NB; i++)
     {
    // Check if mouse is over the handle
    m_bIsHovered[i] = cf.dist(cf.mouseX, cf.mouseY-cf.moniterY, m_x[i], m_y[i]) <= cf.size[i]/2;
    // If we are not already dragging and left mouse is pressed over the handle
    if (!bAlreadyDragging && cf.mousePressed && cf.mouseButton == LEFT && m_bIsHovered[i])
    {
      // We record the state
      m_bDragged[i] = true;
      // And memorize the offset of the mouse position from the center of the handle
      m_clickDX = cf.mouseX - m_x[i];
      m_clickDY = cf.mouseY-cf.moniterY - m_y[i];
    }
    // If mouse isn't pressed
    if (!cf.mousePressed)
    {
      // Any possible dragging is stopped
      m_bDragged[i] = false;
    }

    //m_knobSize = cf.KNOB[i];
    
    Psize[i] = cf.size[i];

   // println("HD update tern= " + cf.turnNum );
 }

}






public boolean isDragged()
{


  if(m_bDragged[0] == true){
    isD = 0;
  }else if(m_bDragged[1] == true){
    isD = 1;
  }else if(m_bDragged[2] == true){
    isD = 2;
  }else if(m_bDragged[3] == true){
    isD = 3;
  }else if(m_bDragged[4] == true){
    isD = 4;
  }else if(m_bDragged[5] == true){
    isD = 5;
  }else if(m_bDragged[6] == true){
    isD = 6;
  }else if(m_bDragged[7] == true){
    isD = 7;
  }



  return m_bDragged[isD];
  
}

  /**
   * If the handle is dragged, the new position is computed with mouse position,
   * taking in account the offset of mouse with center of handle.
   */
   public void move()
   {

    for (int i=0; i < cf.HANDLE_NB; i++)
    {

      if (m_bDragged[i])
      {
        m_x[i] = cf.mouseX - m_clickDX;
        m_y[i] = cf.mouseY-cf.moniterY - m_clickDY;


    //  m_size[0] = (int)m_knobDX;
    //  m_size[1] = (int)m_knobDY;

    print("m_x= "+m_x[i]+", ");
    println("m_y= "+m_y[i]);
  }

  
}
}

  /**
   * Just draw the handle at current posiiton, with color depending if it is dragged or not.
   */
   public void display()
   {
    //background(0);
      //m_knobSize = m_knobSize[cf.turnNum];

      //println("display_tern= " + cf.turnNum );
      
      cf.strokeWeight(1);
      cf.stroke(100);
      


      if(Psize[0]== cf.size[0]){
        if (m_bDragged[0])
        {
          cf.strokeWeight(3);
          cf.stroke(255,0,0);
          cf.fill(cf.slider1);
          cf.ellipse(m_x[0], m_y[0], Psize[0],Psize[0]);
        }else
        {
          //cf.fill(cf.slider1);
          cf.strokeWeight(1);
          cf.stroke(100);
          cf.fill(0);
          cf.ellipse(m_x[0], m_y[0], Psize[0],Psize[0]);
        }
        
      }





      if(Psize[1]== cf.size[1]){
        if (m_bDragged[1])
        {
          cf.strokeWeight(3);
          cf.stroke(255,0,0);
          cf.fill(cf.slider2);
          cf.ellipse(m_x[1], m_y[1], Psize[1],Psize[1]);
        } else
        {
              //cf.fill(cf.slider1);
              cf.strokeWeight(1);
              cf.stroke(100);
              cf.fill(0);
              cf.ellipse(m_x[1], m_y[1], Psize[1],Psize[1]);

            }
            
          }





      if(Psize[2]== cf.size[2]){
        if (m_bDragged[2])
        {
          cf.strokeWeight(3);
          cf.stroke(255,0,0);
          cf.fill(cf.slider3);
          cf.ellipse(m_x[2], m_y[2], Psize[2],Psize[2]);
        } else
        {
              //cf.fill(cf.slider1);
              cf.strokeWeight(1);
              cf.stroke(100);
              cf.fill(0);
              cf.ellipse(m_x[2], m_y[2], Psize[2],Psize[2]);

            }
            
          }



      if(Psize[3]== cf.size[3]){
        if (m_bDragged[3])
        {
          cf.strokeWeight(3);
          cf.stroke(255,0,0);
          cf.fill(cf.slider4);
          cf.ellipse(m_x[3], m_y[3], Psize[3],Psize[3]);
        } else
        {
              //cf.fill(cf.slider1);
              cf.strokeWeight(1);
              cf.stroke(100);
              cf.fill(0);
              cf.ellipse(m_x[3], m_y[3], Psize[3],Psize[3]);

            }
            
          }


      if(Psize[4]== cf.size[4]){
        if (m_bDragged[4])
        {
          cf.strokeWeight(3);
          cf.stroke(255,0,0);
          cf.fill(cf.slider5);
          cf.ellipse(m_x[4], m_y[4], Psize[4],Psize[4]);
        } else
        {
              //cf.fill(cf.slider1);
              cf.strokeWeight(1);
              cf.stroke(100);
              cf.fill(0);
              cf.ellipse(m_x[4], m_y[4], Psize[4],Psize[4]);

            }
            
          }





                if(Psize[5]== cf.size[5]){
        if (m_bDragged[5])
        {
          cf.strokeWeight(3);
          cf.stroke(255,0,0);
          cf.fill(cf.slider6);
          cf.ellipse(m_x[5], m_y[5], Psize[5],Psize[5]);
        } else
        {
              //cf.fill(cf.slider1);
              cf.strokeWeight(1);
              cf.stroke(100);
              cf.fill(0);
              cf.ellipse(m_x[5], m_y[5], Psize[5],Psize[5]);

            }
            
          }




                if(Psize[6]== cf.size[6]){
        if (m_bDragged[6])
        {
          cf.strokeWeight(3);
          cf.stroke(255,0,0);
          cf.fill(cf.slider7);
          cf.ellipse(m_x[6], m_y[6], Psize[6],Psize[6]);
        } else
        {
              //cf.fill(cf.slider1);
              cf.strokeWeight(1);
              cf.stroke(100);
              cf.fill(0);
              cf.ellipse(m_x[6], m_y[6], Psize[6],Psize[6]);

            }
            
          }


                if(Psize[7]== cf.size[7]){
        if (m_bDragged[7])
        {
          cf.strokeWeight(3);
          cf.stroke(255,0,0);
          cf.fill(cf.slider8);
          cf.ellipse(m_x[7], m_y[7], Psize[7],Psize[7]);
        } else
        {
              //cf.fill(cf.slider1);
              cf.strokeWeight(1);
              cf.stroke(100);
              cf.fill(0);
              cf.ellipse(m_x[7], m_y[7], Psize[7],Psize[7]);

            }
            
          }



}
}
/*
PhiLhoSoft's Processing sketches.
http://processing.org/

by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr & http://PhiLho.deviantART.com
*/
/* File/Project history:
 2.00.000 -- 2012/11/13 (PL) -- Separate Handle and HandleList, standard method names.
 */
/* Copyright notice: For details, see the following file:
http://Phi.Lho.free.fr/softwares/PhiLhoSoft/PhiLhoSoftLicense.txt
This program is distributed under the zlib/libpng license.
Copyright (c) 2008-2012 Philippe Lhoste / PhiLhoSoft
*/

/**
 * A list of handles.
 */
 class HandleList
 {
  private ArrayList<Handle> m_handles = new ArrayList<Handle>();
  private boolean m_bDragging;
  private boolean m_bGroupDragging; // True if you want to be able to drag several handles at once (if they are on the same position)

  Handle hh;
  HandleList()
  {
  }

  HandleList(boolean bGroupDragging)
  {
    m_bGroupDragging = bGroupDragging;
  }

  public void add(Handle h)
  {
    m_handles.add(h);

    hh = h;

    for(int i=0; i < cf.HANDLE_NB; i++){
      h.m_x[i] = cf.width/2;
      h.m_y[i] = cf.moniterY+height/2;
    }
      //println("m_handles.add(h)");
    }

    public void update()
    {
    //int why=0;
    // We suppose we are not dragging by default
    boolean bDragging = false;

    // Check each handle
    //for (Handle h : m_handles)
    //{
      // Check if the user ries to drag it
      hh.update(m_bDragging);
      // Ah, this one is indeed dragged! 
      if (hh.isDragged())
      {
        // We will remember a dragging is being done
        bDragging = true;
        if (!m_bGroupDragging)
        {
          m_bDragging = true; // Notify immediately we are dragging something
        }
        // And we move it to the mouse position
        hh.move();
      }
      // In all cases, we redraw the handle
      hh.display();
    //  println("why= " +why);
    //  why++;
    
    // If no dragging is found, we reset the state
    m_bDragging = bDragging;

 // }

}


}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "black_amoeba_part2_0318_01" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
