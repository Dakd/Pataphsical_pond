import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import java.util.HashMap; 
import java.util.Map; 
import javax.sound.midi.Receiver; 
import javax.sound.midi.MidiMessage; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class black_amoeba_part2_0221_01 extends PApplet {

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

public void settings() {
  size(400, 400);
}

public void setup() {
  cf = new ControlFrame(this, 400, 800, "Controls");
  surface.setLocation(802, 0);
  noStroke();
}

public void draw() {
  background(255);
  fill(100);
  rect(50,50,cf.MIDImsg[2], cf.MIDImsg[2]);
}
class ControlFrame extends PApplet {


  Map<String, String> midimapper = new HashMap<String, String>();

  int cols = 21;
  int rows = 4;
  int[] layoutX = new int[cols]; // layout grid for NanoKONTROL2
  int[] layoutY = new int[rows]; // layout grid for NanoKONTROL2
  int sliderVal;
  int turn;
  int moniterY = 210;

  final int HANDLE_NB = 8;
  HandleList handles = new HandleList(false);



  float xOffset = 0.0f;
  float yOffset = 0.0f;



  int knob1, knob2, knob3, knob4, knob5, knob6, knob7, knob8;
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






     //\ub3d9\uadf8\ub77c\ubbf8 \ucd94\uac00
    for (int i = 0; i < HANDLE_NB; i++)
    {


      int size = PApplet.parseInt(random(15, 30));
      handles.add(new Handle(size + random(width - 2 * size), size + random((height - 2 * size)-moniterY),
        size, size / 5,
        color(random(0, 128), 0, 0), color(0, random(200, 255), 0),
        color(0, 0, random(200, 255)), color(random(200, 255), random(90, 140), 0)
        ));
        
    }






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


                //\u5a9b? \u8e30\uafaa\ub4c9 \u8e30\u2464\uca9f\u5a9b?, index.toString ??? \u8e30\uafaa\ub4c9 \u91ab\ub085\uca9f ?\ube23?\ube18?\uada1?\ub497 ?\uc524?\ub733?\ub4aa
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
              println("slider2");
            }
            if ( b[1] == 2) {
              println("slider3");
            }
            if ( b[1] == 3) {
              println("slider4");
            }
            if ( b[1] == 4) {
              println("slider5");
            }
            if ( b[1] == 5) {
              println("slider6");
            }
            if ( b[1] == 6) {
              println("slider7");
            }
            if ( b[1] == 7) {
              println("slider8");
            }



            //knob
            if ( b[1] == 16) {
              knob1 = b[2];
              println("knob1");
            }
            if ( b[1] == 17) {
              println("knob2");
            }
            if ( b[1] == 18) {
              println("knob3");
            }
            if ( b[1] == 19) {
              println("knob4");
            }
            if ( b[1] == 20) {
              println("knob5");
            }
            if ( b[1] == 21) {
              println("knob6");
            }
            if ( b[1] == 22) {
              println("knob7");
            }
            if ( b[1] == 23) {
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

    //\uf9cf\u2465\ub021 \uf9cf\u2464\ub572?\uaf63 \uf9e1?
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
  float m_x, m_y, m_x2, m_y2; // Position of handle
  // int[] m_size[]; // Diameter of handle
  int m_lineWidth, m_lineWidth2;
  int num=0;
  int m_colorLine;
  int m_colorFill;
  int m_colorHover;
  int m_colorDrag;
  int CFturn;
  //m_size[] = new int [8];
  int[] m_size = new int[8];

  private boolean m_bIsHovered, m_bDragged;
  private float m_clickDX, m_clickDY;

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



  Handle(float x, float y, int size, int lineWidth,
    int colorLine, int colorFill, int colorHover, int colorDrag
    )
  {

    //if (num < cf.HANDLE_NB)
    //{
      m_x = x;
      m_y = y;
      m_size[turn] = size;
      m_lineWidth = lineWidth;
      m_colorLine = colorLine;
      m_colorFill = colorFill;
      m_colorHover = colorHover;
      m_colorDrag = colorDrag;

    //  println("tern= " + num);
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
    if (num < cf.HANDLE_NB)
    {
      // Check if mouse is over the handle
      m_bIsHovered = cf.dist(cf.mouseX, cf.mouseY-cf.moniterY, m_x, m_y) <= m_size[num] +  + cf.knob1 / 2;
      // If we are not already dragging and left mouse is pressed over the handle
      if (!bAlreadyDragging && cf.mousePressed && cf.mouseButton == LEFT && m_bIsHovered)
      {
        // We record the state
        m_bDragged = true;
        // And memorize the offset of the mouse position from the center of the handle
        m_clickDX = cf.mouseX - m_x;
        m_clickDY = cf.mouseY-cf.moniterY - m_y;
      }
      // If mouse isn't pressed
      if (!cf.mousePressed)
      {
        // Any possible dragging is stopped
        m_bDragged = false;
      }
    }
    //num++;
  }

  public boolean isDragged()
  {
    return m_bDragged;
  }

  /**
   * If the handle is dragged, the new position is computed with mouse position,
   * taking in account the offset of mouse with center of handle.
   */
  public void move()
  {
    if (m_bDragged)
    {
      m_x = cf.mouseX - m_clickDX;
      m_y = cf.mouseY-cf.moniterY - m_clickDY;

      print("m_x= "+m_x+", ");
      println("m_y= "+m_y);
    }
  }

  /**
   * Just draw the handle at current posiiton, with color depending if it is dragged or not.
   */
  public void display()
  {


    cf.strokeWeight(m_lineWidth);
    cf.stroke(m_colorLine);
    if (m_bDragged)
    {
      cf.fill(m_colorDrag);
    } else if (m_bIsHovered)
    {
      cf.fill(m_colorHover);
    } else
    {
      cf.fill(m_colorFill);
    }

    cf.ellipse(m_x, m_y, m_size[0] + cf.knob1, m_size[0] + cf.knob1);
    cf.ellipse(m_x2, m_y2, m_size[1] + cf.knob2, m_size[1] + cf.knob2);
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
  }

  public void update()
  {
    // We suppose we are not dragging by default
    boolean bDragging = false;
    // Check each handle
    for (Handle h : m_handles)
    {
      // Check if the user tries to drag it
      h.update(m_bDragging);
      // Ah, this one is indeed dragged!
      if (h.isDragged())
      {
        // We will remember a dragging is being done
        bDragging = true;
        if (!m_bGroupDragging)
        {
          m_bDragging = true; // Notify immediately we are dragging something
        }
        // And we move it to the mouse position
        h.move();
      }
      // In all cases, we redraw the handle
      h.display();
    }
    // If no dragging is found, we reset the state
    m_bDragging = bDragging;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "black_amoeba_part2_0221_01" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
