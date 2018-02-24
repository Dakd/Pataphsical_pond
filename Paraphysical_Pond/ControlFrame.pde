class ControlFrame extends PApplet {


  Map<String, String> midimapper = new HashMap<String, String>();

  String time;
  int timeValue;

  int cols = 21;
  int rows = 4;
  int[] layoutX = new int[cols]; // layout grid for NanoKONTROL2
  int[] layoutY = new int[rows]; // layout grid for NanoKONTROL2
  int sliderVal;
  int turnNum=0;
  int moniterY = 160;
  int index;

  int depthW = 600;
  int depthH = 594;
  int bri;
  int listN=1;
  
  int Pswitch = 0;
  int sTime = 60;
  
  //종료 시간 설정 시 + 분
  int closeTime = 2350;

  // int HDindex = 0;



  final int HANDLE_NB = 8;
  HandleList handles = new HandleList(false);


  PImage controlSC;

  float xOffset = 0.0;
  float yOffset = 0.0;
  float left = 360;
  float right = 360;
  float defaultPos = 360;
  float step = 0.1;



  int[] KNOB = new int[10];
  int slider1, slider2, slider3, slider4, slider5, slider6, slider7, slider8;
  boolean rec=false;
  boolean play=false;
  boolean stop=false;

  boolean depthMODE = false;
  boolean defaultMODE = true;
  boolean drawMODE = false;
  boolean interMODE = false;
  boolean centerResetMODE = false;
  boolean centerReturn = false;
  boolean leftR = false;
  boolean rightR = false;
  boolean exitMode = false;

  //boolean drawMODE = false;'

  byte[] MIDImsg = new byte[100];

  String[] sliders = new String[7];
  String[] knobs = new String[7];
  String[] bts = new String[34];
  String[] motionSet = new String[10];
  String folderName;




  int cSize;
  boolean labelVisibility = true;

  boolean trackP, trackN;
  boolean playMODE = false;
  boolean recMODE = false;
  boolean stopMODE = false;

  boolean rec1, rec2, rec3, rec4, rec5, rec6, rec7, rec8 = false;
  boolean play1, play2, play3, play4, play5, play6, play7, play8 = false;


  int w, h;
  PApplet parent;
  ControlP5 cp5;
  SDrop drop;

  DropdownList d1;
  File DIR = new File(dir + "/data");
  String[] list;



  int[] size = new int[100];

  int cnt = 0;



  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();
    parent = _parent;
    w=800;
    h=260;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {

    size( 600, 754);
    smooth(8);
    w = 600;
    h = 200;
    cSize = int(w/(cols+1)/2);
  }

  public void setup() {

    surface.setLocation(0, 0);
   // background(100);

   // fill(0);
   // rect(0, 0, width, height);


    frameRate(30);
    controlSC = createImage(600, 594, RGB);
    drop = new SDrop(this);
    cp5 = new ControlP5(this);




    // create a DropdownList, 
    d1 = cp5.addDropdownList("FILELOAD")
      .setPosition(3, 163)
      ;


    list = DIR.list();



    if (list.length == 0) {
      println("Folder does not exist or cannot be accessed.");
      folderName = str(year()) + str(month() )+ str(day() )+ str(hour() )+ str(minute() )+ str(second());
      output1 = createWriter(dir + "/data/"+ folderName + "/positions01.txt");
      output2 = createWriter(dir + "/data/"+ folderName + "/positions02.txt");
      output3 = createWriter(dir + "/data/"+ folderName + "/positions03.txt");
      output4 = createWriter(dir + "/data/"+ folderName + "/positions04.txt");
      output5 = createWriter(dir + "/data/"+ folderName + "/positions05.txt");
      output6 = createWriter(dir + "/data/"+ folderName + "/positions06.txt");
      output7 = createWriter(dir + "/data/"+ folderName + "/positions07.txt");
      output8 = createWriter(dir + "/data/"+ folderName + "/positions08.txt");
    } else {
      println("//////// folder list ////////////");
      for (int i=0; i < list.length; i++) {
        println(list[i]);
        //println("list.length = " + list.length);
      }
      println("/////////////////////////////////");
      folderName = list[0];
    }


    customize(d1); // customize the first list


    //동그라미 만들기 
    for (int i = 0; i < HANDLE_NB; i++)
    {

      //turnNum++;
      //int size = int(random(15, 30));

      handles.add(new Handle( 
        //X위치
        size[i] + random(width - 2 * size[i]), 
        //Y위치 
        size[i] + random((height - 2 * size[i])-moniterY), 
        //크기
        size[i], size[i] / 5, 
        //색상6
        color(255, 0, 0), color(0, 255, 0), 
        color(0, 0, 255), color(255, 255, 0)
        ));

      turnNum = i;
      //println("turnNum= " + turnNum);
    }




    /*
   give each layout colomn and row a absolute x and y
     in order to easily place controller in a layout grid
     */
    for (int x = 0; x < layoutX.length; x++) {
      for (int y = 0; y < layoutY.length; y++) {
        layoutX[x] = int(w/(cols+1) * (x+1));
        layoutY[y] = int(h/(rows+1) * (y+1));
      }
    }






    sliders[0] = "slider1";










    cp5 = new ControlP5( this );
    cp5.setPosition(-cSize/2, (-cSize/2) - 30); // serves like rectmode CENTER
    // I'd like to align all the labels at once to the center, but don't know how
    //cp5.getAll().alignLabel(CENTER);
    cp5.setColorCaptionLabel(#2F315D); 

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
      cp5.addSlider("sl"+(counter))
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

    cp5.addBang("tP")
      .setPosition(layoutX[0], layoutY[1])
      .setSize(cSize, cSize)
      .setLabelVisible(labelVisibility)
      ;
    cp5.addBang("tN")
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
    cp5.addBang("mP")
      .setPosition(layoutX[3], layoutY[2])
      .setSize(cSize, cSize)
      .setLabelVisible(labelVisibility)
      ;
    cp5.addBang("mN")
      .setPosition(layoutX[4], layoutY[2])
      .setSize(cSize, cSize)
      .setLabelVisible(labelVisibility)
      ;

    cp5.addBang("rew")
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

    cp5.addButton("NEW")
      //.setValue(6649)
      .setPosition(553, 199)
      .setSize(50, 15)
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




            //slider
            if ( b[1] == 0) {
              slider1 = (int)map(b[ 2 ], 0, 127, 0, 255);
              // println("slider1");
            }
            if ( b[1] == 1) {
              slider2 = (int)map(b[ 2 ], 0, 127, 0, 255);
              //println("slider2");
            }
            if ( b[1] == 2) {
              slider3 = (int)map(b[ 2 ], 0, 127, 0, 255);
              println("slider3");
            }
            if ( b[1] == 3) {
              slider4 = (int)map(b[ 2 ], 0, 127, 0, 255);
              // println("slider4");
            }
            if ( b[1] == 4) {
              slider5 = (int)map(b[ 2 ], 0, 127, 0, 255);
              // println("slider5");
            }
            if ( b[1] == 5) {
              slider6 = (int)map(b[ 2 ], 0, 127, 0, 255);
              // println("slider6");
            }
            if ( b[1] == 6) {
              slider7 = (int)map(b[ 2 ], 0, 127, 0, 255);
              // println("slider7");
            }
            if ( b[1] == 7) {
              slider8 = (int)map(b[ 2 ], 0, 127, 0, 255);
              //  println("slider8");
            }



            //knob
            if ( b[1] == 16) {
              KNOB[0] = b[2];
              size[0] = b[2];
              //  println("knob1");
            }
            if ( b[1] == 17) {
              KNOB[1] = b[2];
              size[1] = b[2];
              //  println("knob2");
            }
            if ( b[1] == 18) {
              KNOB[2] = b[2];
              size[2] = b[2];
              //  println("knob3");
            }
            if ( b[1] == 19) {
              KNOB[3] = b[2];
              size[3] = b[2];
              //  println("knob4");
            }
            if ( b[1] == 20) {
              KNOB[4] = b[2];
              size[4] = b[2];
              // println("knob5");
            }
            if ( b[1] == 21) {
              KNOB[5] = b[2];
              size[5] = b[2];
              //  println("knob6");
            }
            if ( b[1] == 22) {
              KNOB[6] = b[2];
              size[6] = b[2];
              //  println("knob7");
            }
            if ( b[1] == 23) {
              KNOB[7] = b[2];
              size[7] = b[2];
              //  println("knob8");
            }



            //button
            if ( b[1] == 42) {

              if (stopMODE == false) {
                stopMODE = true;
                println("stop ON");
              } else {
                stopMODE = false;
                println("stop OFF");
              }
            }
            if ( b[1] == 41) {

              if (playMODE == false) {
                //index = 0;
                playMODE = true;

                println("Play ON");
              } else {
                playMODE = false;
                println("Play OFF");
              }
            }
            if ( b[1] == 45) {
              if (recMODE == false) {
                recMODE = true;
                println("REC ON");
              } else {
                recMODE = false;
                println("REC OFF");
              }
            }




            //개별 녹화 버튼('S')
            if ( b[1] == 64) {
              if (rec1 == false) {
                //list = DIR.list();
                rec1 = true;
                if(recMODE == true){
                output1 = createWriter(dir + "/data/"+ folderName + "/positions01.txt");
                println("Point 1 REC");
                }
              } else {
                rec1 = false;
                
                if(recMODE == true){
                output1.flush();
                output1.close();
                //index = 0;
                println("Point 1 REC stop!");
                }
              }
            }
            if ( b[1] == 65) {
              if (rec2 == false) {
                //list = DIR.list();
                rec2 = true;
                
                if(recMODE == true){
                output2 = createWriter(dir + "/data/"+ folderName + "/positions02.txt");
                println("Point 2 REC");
                }
              } else {
                rec2 = false;
                
                if(recMODE == true){
                output2.flush();
                output2.close();
                //index = 0;
                println("Point 2 REC stop!");
                }
              }
            }
            if ( b[1] == 66) {
              if (rec3 == false) {
                //list = DIR.list();
                rec3 = true;
                
                if(recMODE == true){
                output3 = createWriter(dir + "/data/"+ folderName + "/positions03.txt");
                println("Point 3 REC");
                }
              } else {
                rec3 = false;
                
                if(recMODE == true){
                output3.flush();
                output3.close();
                //index = 0;
                println("Point 3 REC stop!");
                }
              }
            }
            if ( b[1] == 67) {
              if (rec4 == false) {
                //list = DIR.list();
                rec4 = true;
                
                if(recMODE == true){
                output4 = createWriter(dir + "/data/"+ folderName + "/positions04.txt");
                println("Point 4 REC");
                }
              } else {
                rec4 = false;
                
                if(recMODE == true){
                output4.flush();
                output4.close();
                //index = 0;
                println("Point 4 REC stop!");
                }
              }
            }
            if ( b[1] == 68) {
              if (rec5 == false) {
                //list = DIR.list();
                rec5 = true;
                
                if(recMODE == true){
                output5 = createWriter(dir + "/data/"+ folderName + "/positions05.txt");
                println("Point 5 REC");
                }
              } else {
                rec5 = false;
                
                if(recMODE == true){
                output5.flush();
                output5.close();
                //index = 0;
                println("Point 5 REC stop!");
                }
              }
            }
            if ( b[1] == 69) {
              if (rec6 == false) {
                //list = DIR.list();
                rec6 = true;
                
                if(recMODE == true){
                output6 = createWriter(dir + "/data/"+ folderName + "/positions06.txt");
                println("Point 6 REC");
                }
              } else {
                rec6 = false;
                
                if(recMODE == true){
                output6.flush();
                output6.close();
                //index = 0;
                println("Point 6 REC stop!");
                }
              }
            }
            if ( b[1] == 70) {
              if (rec7 == false) {
                //list = DIR.list();
                rec7 = true;
                
                if(recMODE == true){
                output7 = createWriter(dir + "/data/"+ folderName + "/positions07.txt");
                println("Point 7 REC");
                }
              } else {
                rec7 = false;
                
                if(recMODE == true){
                output7.flush();
                output7.close();
                //index = 0;
                println("Point 7 REC stop!");
                }
              }
            }
            if ( b[1] == 71) {
              if (rec8 == false) {
                //list = DIR.list();
                rec8 = true;
                if(recMODE == true){
                output8 = createWriter(dir + "/data/"+ folderName + "/positions08.txt");
                println("Point 8 REC");
                }
              } else {
                rec8 = false;
                if(recMODE == true){
                output8.flush();
                output8.close();
                //index = 0;
                println("Point 8 REC stop!");
                }
              }
            }


            //개별 플레이 버튼('S')
            if ( b[1] == 32) {
              if (play1 == false) {
                play1 = true;

                println("Play1 ON");
              } else {
                play1 = false;
                println("Play1 OFF");
              }
            }
            if ( b[1] == 33) {
              if (play2 == false) {
                play2 = true;

                println("Play2 ON");
              } else {
                play2 = false;
                println("Play2 OFF");
              }
            }
            if ( b[1] == 34) {
            }
            if ( b[1] == 35) {
            }
            if ( b[1] == 36) {
            }
            if ( b[1] == 37) {
            }
            if ( b[1] == 38) {
            }
            if ( b[1] == 39) {
            }
          }
        }

        @Override public void close( ) {
        }
      }
      );
    }
   
   
   
    //파워 ON!
    powerSwitch = true;
    println("powerSwitch ON!");
    
    //처음시작 리셋
    //centerResetMODE = true;
    //playMODE = true;
    println("Now FolderName : " + folderName);
  }


  String ref(String theDevice, int theIndex) {
    return theDevice+"-"+theIndex;
  }

  void draw() {
    
    
    rectMode(CORNER);
    background(23,24,57);
    if (defaultMODE == true && drawMODE == false && interMODE == false) {  
      //컨트롤 화면
      pushMatrix();
      translate(0, moniterY);
      noStroke();
      fill(0);
      rect(0, 0, 600, 594);

      if (recMODE == false) {
        image(grid_G, 0, 0, 600, 594);
      } else {
        image(grid_R, 0, 0, 600, 594);
      }

      handles.update();

      if (centerResetMODE == true) {
        centerReset();
      }
      if(exitMode == true ||  timeValue >= closeTime){
        exitMODE();    
    }
      
      
      //라인 테스트
      //strokeWeight(size[1]);
      //noStroke();
      //stroke(slider1);
      ////noFill();
      //fill(slider1);
      ////ellipse(mouseX,mouseY-200,size[0],size[0]);
      //rect(mouseX,mouseY-200,20,80);

      //컨트롤 영상 보내기
      controlSC = this.get(0, moniterY, 600, 594);
      popMatrix();
    } else if (drawMODE == true && defaultMODE == false && interMODE == false) {
      //컨트롤 화면
      pushMatrix();
      translate(0, moniterY);
      //noStroke();
      //fill(0);
      //rect(0, 0, 600, 594);
      //image(grid_G, 0, 0, 600, 594); 
      handles.update();
      if (centerResetMODE == true) {
        centerReset();
      }
      //컨트롤 영상 보내기
      controlSC = this.get(0, moniterY, 600, 594);
      popMatrix();
    } else if (interMODE == true && drawMODE == false && defaultMODE == false ) {  

      //컨트롤 화면
      pushMatrix();
      translate(0, moniterY);



      //컨트롤 영상 보내기
      controlSC = this.get(0, moniterY, 600, 594);
      popMatrix();
    }


    //println("현재시간: " + str(year())+ "년" + str(month() )+ "월"+ str(day() )+ "일"+ str(hour() )+ "시"+ str(minute() )+ "분"+ str(second())+ "초");
    //println("현재시간: " + str(hour() )+ "시 "+ str(minute() )+ "분 "+ str(second())+ "초 ");

    time = str(hour() ) + str(minute());
    //println("time = " + time);

    timeValue = int(time);
    //println("timeValue = " + timeValue);


    if (powerSwitch == true && sTime > 0) {
        myPort[7].write('H'); 
        sTime--;
        println("powerSwitch ON!");
      } else if(sTime > 0){
        myPort[7].write('L');
        //sTime = 60;
        println("powerSwitch OFF!");
      }

//sTime--;

    //switch(Pswitch) {
    //case 1:
    //  myPort[7].write('H');
    //  println("powerSwitch ON!");
    //  break;

    //case 'false':
    //  myPort[7].write('L');
    //  println("powerSwitch OFF!");
    //  break;
    //}
  }

  void keyPressed() {
    if (key == CODED) {

      if (keyCode == java.awt.event.KeyEvent.VK_F1) {
        if (defaultMODE == false) {
          depthMODE = false;
          defaultMODE = true;
        } else {
          depthMODE = true;
          defaultMODE = false;
        }
      }

      if (keyCode == java.awt.event.KeyEvent.VK_F2) {
        if (depthMODE == false) {
          defaultMODE = false;
          depthMODE = true;
        } else {
          defaultMODE = true;
          depthMODE = false;
        }
      }
    }

    if (testMODE == true && keyCode == LEFT) {
    } else if (testMODE == true && keyCode == RIGHT) {
    }


    //녹화 모드 키
    if (key == ' ' && RECmode == false) {
      RECmode = true;
      //output = createWriter("C:/work/black amoeba/Paraphysical_pond_0729_01/data/positions01.txt");
      //HDindex=0;
      println("RECmode true");
    } else if (key == ' ' && RECmode == true) {
      RECmode = false;
      println("RECmode false");
      //output.flush(); // Write the remaining data
      //output.close(); // Finish the file
    }

    if (key=='1') {
      try {
        Process child = Runtime.getRuntime().exec("shutdown -s");
      }
      catch(IOException e) {
        e.printStackTrace();
      }
    } else if (key=='2') {
    } else if (key=='3') {
    } else if (key=='4') {
    } else if (key=='5') {
    } else if (key=='6') {
    } else if (key=='7') {
    } else if (key=='8') {
    } else if (key=='9') {
    } else if (key=='0') {      

      if (centerResetMODE == true) {
        centerResetMODE = false;
        left = defaultPos;
        right = defaultPos;
        leftR = false;
        rightR = false;
        println("center reset STOP! (key)");
      } else {
        centerResetMODE = true;
        println("center reset START");
      }
    }

    //드로우 모드
    if (key == 'd') {

      if (drawMODE == false) {
        drawMODE = true;
        defaultMODE = false;
        println("drawMODE start!");
      } else {
        drawMODE = false;
        defaultMODE = true;
        println("drawMODE stop!");
      }
    }

    //인터렉션 모드
    if (key == 'i') {

      if (interMODE == false) {
        interMODE = true;
        drawMODE = false;
        defaultMODE = false;
        println("interMODE start!");
      } else {
        interMODE = false;
        drawMODE = true;
        defaultMODE = true;
        println("interMODE stop!");
      }
    }
    
    //종료 모드
    if (key == 'x') {
      
      if (exitMode == false) {
        exitMode = true;
         println("exitMode");
      } else {
        exitMode = false;
      }    
    }
    


    //파워 스위치
    if (key == 'p') {

      if (powerSwitch == false) {
        powerSwitch = true;
        //myPort[7].write('H'); 
        //println("powerSwitch ON!");
      } else {
        powerSwitch = false;
        sTime = 60;
        //myPort[7].write('L');
        //println("powerSwitch OFF!");
      }
    }
  }


  void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
  {
    noFill();
    Blob b;
    EdgeVertex eA, eB;

    int i = 0;
    //println("blobNum: "+ theBlobDetection.getBlobNb());

    //lerpX = xPos;
    //lerpY = yPos;    

    for (int n=0; n<theBlobDetection.getBlobNb(); n++)
    {
      b=theBlobDetection.getBlob(n);
      if (b!=null)
      {
        // Edges
        if (drawEdges)
        {
          strokeWeight(3);
          stroke(0, 255, 0);
          for (int m=0; m<b.getEdgeNb(); m++)
          {
            eA = b.getEdgeVertexA(m);
            eB = b.getEdgeVertexB(m);
            if (eA !=null && eB !=null)
              line(
                eA.x*depthW, eA.y*depthH, 
                eB.x*depthW, eB.y*depthH
                );
          }
        }

        // Blobs
        if (drawBlobs && b.w*depthW > 20 && b.h*depthH > 20 &&  i < 3)
        {

          blobWidth = int(b.w*depthW);
          blobheight = int(b.h*depthH);

          println("i" + i);
          onePlayer = true;





          //strokeWeight(1);
          //stroke(0, 0, 255);
          //rect(
          //  b.xMin*width, b.yMin*height, 
          //  b.w*width, b.h*height
          //  );


          xPos = int((b.xMin*depthW) + b.w*depthW/2);
          yPos = int((b.yMin*depthH) + b.h*depthH/2);





          //point((b.xMin*width) + b.w*width/2, (b.yMin*height) + b.h*height/2);


          targetX = xPos;
          targetY = yPos;


          lerpX = int(lerp(lerpX, targetX, 0.1));
          lerpY = int(lerp(lerpY, targetY, 0.1));


          strokeWeight(40);
          stroke(255);
          point(xPos, yPos + moniterY );

          i++;
        } else if (drawBlobs && b.w*depthW < 20 && b.h*depthH < 20 && i == 0) {

          onePlayer = false;
        }
      }
    }
  }

  void customize(DropdownList ddl) {
    // a convenience function to customize a DropdownList

    ddl.clear();
    ddl.setBackgroundColor(color(190));   
    ddl.setItemHeight(20);
    ddl.setBarHeight(15);
    ddl.getCaptionLabel().set("file load");
    //ddl.setFont(font);
    ddl.addItems(list);
    ddl.setColorBackground(color(60));
    ddl.setColorActive(color(255, 128));
    ddl.close();
  }


  public void NEW(int theValue) {

    d1.clear();

    println("NEW");
    println("Folder does not exist or cannot be accessed.");
    folderName = str(year()) + str(month() )+ str(day() )+ str(hour() )+ str(minute() )+ str(second());
    output1 = createWriter(dir + "/data/"+ folderName + "/positions01.txt");
    output2 = createWriter(dir + "/data/"+ folderName + "/positions02.txt");
    output3 = createWriter(dir + "/data/"+ folderName + "/positions03.txt");
    output4 = createWriter(dir + "/data/"+ folderName + "/positions04.txt");
    output5 = createWriter(dir + "/data/"+ folderName + "/positions05.txt");
    output6 = createWriter(dir + "/data/"+ folderName + "/positions06.txt");
    output7 = createWriter(dir + "/data/"+ folderName + "/positions07.txt");
    output8 = createWriter(dir + "/data/"+ folderName + "/positions08.txt");


    list = DIR.list();

    customize(d1);
  }

  public void FILELOAD(ControlEvent theEvent) {
    //println("a button event from colorA: "+theValue);
    folderName = list[(int)theEvent.getValue()];
    println("folderName = " + folderName);
  }

  void centerReset() {

//리턴하기 
    if (left <= 0) {
      leftR = true;
    }

    if (right >= 600) {
      rightR = true;
    }



//우측 라인
    if (rightR == false) {  
      rectMode(CENTER);
      noStroke();
      fill(100);
      rect(right, 500, 20, 1000);

      right = right + step;
    } else if (right > defaultPos) {
      rectMode(CENTER);
      noStroke();
      fill(100);
      rect(right, 500, 20, 1000);

      right = right - step;
    } 
    
    //else if (right == defaultPos) {
    //  println("centerReset STOP!");
    //  centerResetMODE = false;
    //  left = defaultPos;
    //  right = defaultPos;
    //  leftR = false;
    //  rightR = false;

    //  right = right - step;

    //  //cf.folderName = cf.list[0];
    //  //cf.listN = 1;

    //  playMODE = true;
    //  centerResetMODE = false;
    //}



//좌측라인
    if (leftR == false) {  
      rectMode(CENTER);
      noStroke();
      fill(200);
      rect(left, 500, 20, 1000);

      left = left - step;
    } else if (left < defaultPos) {
      rectMode(CENTER);
      noStroke();
      fill(200);
      rect(left, 500, 20, 1000);

      left = left + step;
    }else if (left == defaultPos) {
      centerResetMODE = false;
      println("centerReset STOP!!!");
      centerResetMODE = false;
      left = defaultPos;
      right = defaultPos;
      leftR = false;
      rightR = false;

      left = left + step;

      //cf.folderName = cf.list[0];
      //cf.listN = 1;

      playMODE = true;
      
    }
    
    
  }
  
  void exitMODE(){
    
    playMODE = false;
    
    //리턴하기 
    if (left <= 0) {
      leftR = true;
    }

    if (right >= 600) {
      rightR = true;
    }



//우측 라인
    if (rightR == false) {  
      rectMode(CENTER);
      noStroke();
      fill(100);
      rect(right, 500, 20, 1000);

      right = right + step;
    } else if (right > defaultPos) {
      rectMode(CENTER);
      noStroke();
      fill(100);
      rect(right, 500, 20, 1000);

      right = right - step;
    } 
    

//좌측라인
    if (leftR == false) {  
      rectMode(CENTER);
      noStroke();
      fill(200);
      rect(left, 500, 20, 1000);

      left = left - step;
    } else if (left < defaultPos) {
      rectMode(CENTER);
      noStroke();
      fill(200);
      rect(left, 500, 20, 1000);

      left = left + step;
    }else if (left == defaultPos) {
      centerResetMODE = false;
      println("centerReset STOP!!!");
      centerResetMODE = false;
      left = defaultPos;
      right = defaultPos;
      leftR = false;
      rightR = false;

      left = left + step;

      
      myPort[7].write('L');
      println("powerSwitch OFF!");
      
      delay(3000);
      exit();
     
    } 
  }
}