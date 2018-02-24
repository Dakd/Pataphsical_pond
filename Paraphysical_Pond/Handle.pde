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



  //int index0;
  int index1, index2, index3, index4, index5, index6, index7, index8;
  String[] lines1, lines2, lines3, lines4, lines5, lines6, lines7, lines8;



  color m_colorLine;
  color m_colorFill;
  //color m_colorHover;
  color[] m_colorHover = new color[10];

  color m_colorDrag;



  //포인터 컬러
  color defaultColor = color(0, 255, 0);
  ;
  color mouseOnColor;
  color dragColor = color(0, 0, 0);
  ;
  int[] magPower = new int[7];





  //m_size[] = new int [8];
  int[] m_size = new int[10];
  int[] Psize = new int[10];

  int isD;

  //private boolean m_colorHover;

  boolean[] m_bDragged = new boolean[10];
  boolean[] m_bIsHovered = new boolean[10];
  boolean line1Done = false;
  boolean line2Done = false;
  boolean line3Done = false;
  boolean line4Done = false;
  boolean line5Done = false;
  boolean line6Done = false;
  boolean line7Done = false;
  boolean line8Done = false;


  private float m_clickDX, m_clickDY;
  private int m_knobSize;





  int x1, x2, x3, x4, x5, x6, x7, x8;
  int y1, y2, y3, y4, y5, y6, y7, y8;
  int stroke1, stroke2, stroke3, stroke4, stroke5, stroke6, stroke7, stroke8;
  int bri1, bri2, bri3, bri4, bri5, bri6, bri7, bri8;
  int size1, size2, size3, size4, size5, size6, size7, size8;






  Handle(float x, float y, int size, int lineWidth, 
    color colorLine, color colorFill, color colorHover, color colorDrag
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
  void update(boolean bAlreadyDragging)
  {


    lines1 = loadStrings("/data/"+ cf.folderName + "/positions01.txt");
    lines2 = loadStrings("/data/"+ cf.folderName + "/positions02.txt");
    lines3 = loadStrings("/data/"+ cf.folderName + "/positions03.txt");
    lines4 = loadStrings("/data/"+ cf.folderName + "/positions04.txt");
    lines5 = loadStrings("/data/"+ cf.folderName + "/positions05.txt");
    lines6 = loadStrings("/data/"+ cf.folderName + "/positions06.txt");
    lines7 = loadStrings("/data/"+ cf.folderName + "/positions07.txt");
    lines8 = loadStrings("/data/"+ cf.folderName + "/positions08.txt");


    //if ( lines1 != null && lines2 != null && lines3 != null && lines4 != null && lines5 != null && lines6 != null && lines7 != null && lines8 != null || cf.index < lines1.length || cf.index < lines2.length || cf.index < lines3.length || cf.index < lines4.length || cf.index < lines5.length || cf.index < lines6.length || cf.index < lines7.length || cf.index < lines8.length) {


    //}else {
    //  cf.index=0;
    //  cf.folderName = cf.list[listN++];
    //}

    if ( cf.centerResetMODE == false && cf.playMODE == true && line1Done == true && line2Done == true  && line3Done == true && line4Done == true && line5Done == true && line6Done == true && line7Done == true && line8Done == true) {

      line1Done = false;
      line2Done = false;
      line3Done = false;
      line4Done = false;
      line5Done = false;
      line6Done = false;
      line7Done = false;
      line8Done = false;

      cf.index=0;



      if (cf.listN < cf.list.length) {
        // println("왜");
        cf.folderName = cf.list[cf.listN];
        println("Now FolderName : " + cf.folderName);
        cf.listN++;
      } else {      //되돌아 가는 부분

        cf.folderName = cf.list[0];
        cf.listN = 1;
        println("Now FolderName : " + cf.folderName);
        //println("다시");
       // cf.playMODE = false;
       // cf.centerResetMODE = true;
      }

      //println("folderName  = "  + cf.list[listN]);
    }

    //println("cf.list.length = " + cf.list.length);
    //println("cf.list 1 = " + cf.list[3]);


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


    //println("cf.index = " + cf.index);
  }






  boolean isDragged()
  {


    if (m_bDragged[0] == true) {
      isD = 0;
    } else if (m_bDragged[1] == true) {
      isD = 1;
    } else if (m_bDragged[2] == true) {
      isD = 2;
    } else if (m_bDragged[3] == true) {
      isD = 3;
    } else if (m_bDragged[4] == true) {
      isD = 4;
    } else if (m_bDragged[5] == true) {
      isD = 5;
    } else if (m_bDragged[6] == true) {
      isD = 6;
    } else if (m_bDragged[7] == true) {
      isD = 7;
    }



    return m_bDragged[isD];
  }

  /**
   * If the handle is dragged, the new position is computed with mouse position,
   * taking in account the offset of mouse with center of handle.
   */
  void move()
  {

    for (int i=0; i < cf.HANDLE_NB; i++)
    {

      if (m_bDragged[i])
      {
        m_x[i] = cf.mouseX - m_clickDX;
        m_y[i] = cf.mouseY-cf.moniterY - m_clickDY;


        //  m_size[0] = (int)m_knobDX;
        //  m_size[1] = (int)m_knobDY;

        // print("m_x= "+m_x[i]+", ");
        // println("m_y= "+m_y[i]);
      }
    }
  }

  /**
   * Just draw the handle at current posiiton, with color depending if it is dragged or not.
   */
  void display()
  {
    if (cf.rec1 == true || cf.rec2 == true || cf.rec3 == true || cf.rec4 == true || cf.rec5 == true || cf.rec6 == true || cf.rec7 == true || cf.rec8 == true || cf.playMODE == true) {


      if (cf.playMODE == true) {
        cf.index++;
      }
      //println("index = " + index);
      //} else {
      //  cf.index=0;        
      //  cf.folderName = cf.list[listN++];
      //}




      // 녹화 파일 로드
      if (lines1 != null && cf.index < lines1.length) {
        //println("index = " + index);
        String[] pieces1 = split(lines1[cf.index], '\t');
        String[] in1 = split(lines1[0], '\t');
        index1 = int(in1[0]);

        if (pieces1.length == 5) {
          x1 = int(pieces1[1]) ;
          y1 = int(pieces1[2]) ;
          size1 = int(pieces1[3]) ;
          bri1 = int(pieces1[4]) ;
        }
      } else {
        line1Done = true;
        //println("line1Done");
      }
      if (lines2 != null && cf.index < lines2.length) {
        //println("index = " + index);
        String[] pieces2 = split(lines2[cf.index], '\t');
        String[] in2 = split(lines2[0], '\t');
        index2 = int(in2[0]);

        if (pieces2.length == 5) {
          x2 = int(pieces2[1]) ;
          y2 = int(pieces2[2]) ;
          size2 = int(pieces2[3]) ;
          bri2 = int(pieces2[4]) ;
        }
      } else {
        line2Done = true;
        //println("line2Done");
      }

      if (lines3 != null && cf.index < lines3.length) {
        //println("index = " + index);
        String[] pieces3 = split(lines3[cf.index], '\t');
        String[] in3 = split(lines3[0], '\t');
        index3 = int(in3[0]);

        if (pieces3.length == 5) {
          x3 = int(pieces3[1]) ;
          y3 = int(pieces3[2]) ;
          size3 = int(pieces3[3]) ;
          bri3 = int(pieces3[4]) ;
        }
      } else {
        line3Done = true;
        //println("line3Done");
      }

      if (lines4 != null && cf.index < lines4.length) {
        //println("index = " + index);
        String[] pieces4 = split(lines4[cf.index], '\t');
        String[] in4 = split(lines4[0], '\t');
        index4 = int(in4[0]);

        if (pieces4.length == 5) {
          x4 = int(pieces4[1]) ;
          y4 = int(pieces4[2]) ;
          size4 = int(pieces4[3]) ;
          bri4 = int(pieces4[4]) ;
        }
      } else {
        line4Done = true;
        //println("line4Done");
      }

      if (lines5 != null && cf.index < lines5.length) {
        //println("index = " + index);
        String[] pieces5 = split(lines5[cf.index], '\t');
        String[] in5 = split(lines5[0], '\t');
        index5 = int(in5[0]);

        if (pieces5.length == 5) {
          x5 = int(pieces5[1]) ;
          y5 = int(pieces5[2]) ;
          size5 = int(pieces5[3]) ;
          bri5 = int(pieces5[4]) ;
        }
      } else {
        line5Done = true;
        // println("line5Done");
      }

      if (lines6 != null && cf.index < lines6.length) {
        //println("index = " + index);
        String[] pieces6 = split(lines6[cf.index], '\t');
        String[] in6 = split(lines6[0], '\t');
        index6 = int(in6[0]);

        if (pieces6.length == 5) {
          x6 = int(pieces6[1]) ;
          y6 = int(pieces6[2]) ;
          size6 = int(pieces6[3]) ;
          bri6 = int(pieces6[4]) ;
        }
      } else {
        line6Done = true;
        //println("line6Done");
      }

      if (lines7 != null && cf.index < lines7.length) {
        //println("index = " + index);
        String[] pieces7 = split(lines7[cf.index], '\t');
        String[] in7 = split(lines7[0], '\t');
        index7 = int(in7[0]);

        if (pieces7.length == 5) {
          x7 = int(pieces7[1]) ;
          y7 = int(pieces7[2]) ;
          size7 = int(pieces7[3]) ;
          bri7 = int(pieces7[4]) ;
        }
      } else {
        line7Done = true;
        // println("line7Done");
      }

      if (lines8 != null && cf.index < lines8.length) {
        //println("index = " + index);
        String[] pieces8 = split(lines8[cf.index], '\t');
        String[] in8 = split(lines8[0], '\t');
        index8 = int(in8[0]);

        if (pieces8.length == 5) {
          x8 = int(pieces8[1]) ;
          y8 = int(pieces8[2]) ;
          size8 = int(pieces8[3]) ;
          bri8 = int(pieces8[4]) ;
        }
      } else {
        line8Done = true;
        //println("line8Done");
      }








      //재생
      cf.strokeWeight(3);
      cf.stroke(dragColor);

      if (cf.drawMODE == true) {
        cf.noStroke();
      }

      //포인트 1
      if (cf.index >= index1) {
        cf.fill(bri1);
        cf.ellipse(x1, y1, size1, size1);
      }
      //포인트 2
      if (cf.index >= index2) {
        cf.fill(bri2);
        cf.ellipse(x2, y2, size2, size2);
      }
      //포인트 3
      if (cf.index >= index3) {
        cf.fill(bri3);
        cf.ellipse(x3, y3, size3, size3);
      }
      //포인트 4
      if (cf.index >= index4) {
        cf.fill(bri4);
        cf.ellipse(x4, y4, size4, size4);
      }
      //포인트 5
      if (cf.index >= index5) {
        cf.fill(bri5);
        cf.ellipse(x5, y5, size5, size5);
      }
      //포인트 6
      if (cf.index >= index6) {
        cf.fill(bri6);
        cf.ellipse(x6, y6, size6, size6);
      }
      //포인트 7
      if (cf.index >= index7) {
        cf.fill(bri7);
        cf.ellipse(x7, y7, size7, size7);
      }
      //포인트 8
      if (cf.index >= index8) {
        cf.fill(bri8);
        cf.ellipse(x8, y8, size8, size8);
      }









      if (cf.recMODE == true) {
        
        
        
        

        if (Psize[0]== cf.size[0]&& cf.rec1 == true) {
          if (m_bDragged[0])
          {
            cf.strokeWeight(3);
            cf.stroke(dragColor);
            cf.fill(cf.slider1);
            cf.ellipse(m_x[0], m_y[0], Psize[0], Psize[0]);
            //output1.println(cf.index + "\t" + cf.mouseX + "\t" + (cf.mouseY - cf.moniterY) + "\t" + Psize[0] + "\t" + cf.slider1);
            output1.println(cf.index + "\t" +m_x[0] + "\t" + m_y[0] + "\t" + Psize[0] + "\t" + cf.slider1);
          } else
          {
            cf.strokeWeight(1);
            cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[0], m_y[0], Psize[0], Psize[0]);
            output1.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
          cf.index++;
        }

        if (Psize[1]== cf.size[1]&& cf.rec2 == true) {
          //println("rec2 = " + cf.rec2);
          if (m_bDragged[1])
          {
            //println("rec2 = " + cf.rec2);
            cf.strokeWeight(3);
            cf.stroke(dragColor);
            cf.fill(cf.slider2);
            cf.ellipse(m_x[1], m_y[1], Psize[1], Psize[1]);
            //output2.println(cf.index + "\t" + cf.mouseX + "\t" + (cf.mouseY - cf.moniterY) + "\t" + Psize[1] + "\t" + cf.slider2);
            output2.println(cf.index + "\t" + m_x[1] + "\t" + m_y[1] + "\t" + Psize[1] + "\t" + cf.slider2);
          } else 
          {
            cf.strokeWeight(1);
            cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[1], m_y[1], Psize[1], Psize[1]);
            output2.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
          cf.index++;
        }


        if (Psize[2]== cf.size[2]&& cf.rec3 == true) {
          if (m_bDragged[2])
          {
            cf.strokeWeight(3);
            cf.stroke(dragColor);
            cf.fill(cf.slider3);
            cf.ellipse(m_x[2], m_y[2], Psize[2], Psize[2]);
            output3.println(cf.index + "\t" + m_x[2] + "\t" + m_y[2] + "\t" + Psize[2] + "\t" + cf.slider3);
          } else
          {
            //cf.fill(cf.slider1);
            cf.strokeWeight(1);
            cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[2], m_y[2], Psize[2], Psize[2]);
            output3.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
          cf.index++;
        }



        if (Psize[3]== cf.size[3]&& cf.rec4 == true) {
          if (m_bDragged[3])
          {
            cf.strokeWeight(3);
            cf.stroke(dragColor);
            cf.fill(cf.slider4);
            cf.ellipse(m_x[3], m_y[3], Psize[3], Psize[3]);
            output4.println(cf.index + "\t" + m_x[3] + "\t" + m_y[3] + "\t" + Psize[3] + "\t" + cf.slider4);
          } else
          {
            //cf.fill(cf.slider1);
            cf.strokeWeight(1);
            cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[3], m_y[3], Psize[3], Psize[3]);
            output4.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
          cf.index++;
        }


        if (Psize[4]== cf.size[4]&& cf.rec5 == true) {
          if (m_bDragged[4])
          {
            cf.strokeWeight(3);
            cf.stroke(dragColor);
            cf.fill(cf.slider5);
            cf.ellipse(m_x[4], m_y[4], Psize[4], Psize[4]);
            output5.println(cf.index + "\t" + m_x[4] + "\t" + m_y[4] + "\t" + Psize[4] + "\t" + cf.slider5);
          } else
          {
            //cf.fill(cf.slider1);
            cf.strokeWeight(1);
            cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[4], m_y[4], Psize[4], Psize[4]);
            output5.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
          cf.index++;
        }





        if (Psize[5]== cf.size[5]&& cf.rec6 == true) {
          if (m_bDragged[5])
          {
            cf.strokeWeight(3);
            cf.stroke(dragColor);
            cf.fill(cf.slider6);
            cf.ellipse(m_x[5], m_y[5], Psize[5], Psize[5]);
            output6.println(cf.index + "\t" + m_x[5] + "\t" + m_y[5] + "\t" + Psize[5] + "\t" + cf.slider6);
          } else
          {
            //cf.fill(cf.slider1);
            cf.strokeWeight(1);
            cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[5], m_y[5], Psize[5], Psize[5]);
            output6.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
          cf.index++;
        }




        if (Psize[6]== cf.size[6]&& cf.rec7 == true) {
          if (m_bDragged[6])
          {
            cf.strokeWeight(3);
            cf.stroke(dragColor);
            cf.fill(cf.slider7);
            cf.ellipse(m_x[6], m_y[6], Psize[6], Psize[6]);
            output7.println(cf.index + "\t" + m_x[6] + "\t" + m_y[6] + "\t" + Psize[6] + "\t" + cf.slider7);
          } else
          {
            //cf.fill(cf.slider1);
            cf.strokeWeight(1);
            cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[6], m_y[6], Psize[6], Psize[6]);
            output7.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
          cf.index++;
        }


        if (Psize[7]== cf.size[7]&& cf.rec8 == true) {
          if (m_bDragged[7])
          {
            cf.strokeWeight(1);
            cf.stroke(dragColor);
            cf.fill(cf.slider8);
            cf.ellipse(m_x[7], m_y[7], Psize[7], Psize[7]);
            output8.println(cf.index + "\t" + m_x[7] + "\t" + m_y[7] + "\t" + Psize[7] + "\t" + cf.slider8);
          } else
          {
            //cf.fill(cf.slider1);
            cf.strokeWeight(1);
            cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[7], m_y[7], Psize[7], Psize[7]);
            output8.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
          cf.index++;
        }
      } else {
        
      // cf.playMODE = false;

        cf.noStroke();

        if (Psize[0]== cf.size[0]&& cf.rec1 == true) {
          if (m_bDragged[0])
          {
            //cf.strokeWeight(3);
            //cf.stroke(dragColor);
            cf.fill(cf.slider1);
            cf.ellipse(m_x[0], m_y[0], Psize[0], Psize[0]);
            //output1.println(cf.index + "\t" + cf.mouseX + "\t" + (cf.mouseY - cf.moniterY) + "\t" + Psize[0] + "\t" + cf.slider1);
           // output1.println(cf.index + "\t" +m_x[0] + "\t" + m_y[0] + "\t" + Psize[0] + "\t" + cf.slider1);
          } else
          {
            //cf.strokeWeight(1);
            //cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[0], m_y[0], Psize[0], Psize[0]);
            //output1.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
          //cf.index++;
        }

        if (Psize[1]== cf.size[1]&& cf.rec2 == true) {
          //println("rec2 = " + cf.rec2);
          if (m_bDragged[1])
          {
            //println("rec2 = " + cf.rec2);
            //cf.strokeWeight(3);
            //cf.stroke(dragColor);
            cf.fill(cf.slider2);
            cf.ellipse(m_x[1], m_y[1], Psize[1], Psize[1]);
            //output2.println(cf.index + "\t" + cf.mouseX + "\t" + (cf.mouseY - cf.moniterY) + "\t" + Psize[1] + "\t" + cf.slider2);
            //output2.println(cf.index + "\t" + m_x[1] + "\t" + m_y[1] + "\t" + Psize[1] + "\t" + cf.slider2);
          } else 
          {
            //cf.strokeWeight(1);
            //cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[1], m_y[1], Psize[1], Psize[1]);
           // output2.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
          //cf.index++;
        }


        if (Psize[2]== cf.size[2]&& cf.rec3 == true) {
          if (m_bDragged[2])
          {
            //cf.strokeWeight(3);
            //cf.stroke(dragColor);
            cf.fill(cf.slider3);
            cf.ellipse(m_x[2], m_y[2], Psize[2], Psize[2]);
           // output3.println(cf.index + "\t" + m_x[2] + "\t" + m_y[2] + "\t" + Psize[2] + "\t" + cf.slider3);
          } else
          {
            //cf.fill(cf.slider1);
            //cf.strokeWeight(1);
            //cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[2], m_y[2], Psize[2], Psize[2]);
           // output3.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
          //cf.index++;
        }



        if (Psize[3]== cf.size[3]&& cf.rec4 == true) {
          if (m_bDragged[3])
          {
            // cf.strokeWeight(3);
            //cf.stroke(dragColor);
            cf.fill(cf.slider4);
            cf.ellipse(m_x[3], m_y[3], Psize[3], Psize[3]);
           // output4.println(cf.index + "\t" + m_x[3] + "\t" + m_y[3] + "\t" + Psize[3] + "\t" + cf.slider4);
          } else
          {
            //cf.fill(cf.slider1);
            //cf.strokeWeight(1);
            //cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[3], m_y[3], Psize[3], Psize[3]);
           // output4.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
          //cf.index++;
        }


        if (Psize[4]== cf.size[4]&& cf.rec5 == true) {
          if (m_bDragged[4])
          {
            //cf.strokeWeight(3);
            //cf.stroke(dragColor);
            cf.fill(cf.slider5);
            cf.ellipse(m_x[4], m_y[4], Psize[4], Psize[4]);
           // output5.println(cf.index + "\t" + m_x[4] + "\t" + m_y[4] + "\t" + Psize[4] + "\t" + cf.slider5);
          } else
          {
            //cf.fill(cf.slider1);
            //cf.strokeWeight(1);
            //cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[4], m_y[4], Psize[4], Psize[4]);
           // output5.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
          //cf.index++;
        }





        if (Psize[5]== cf.size[5]&& cf.rec6 == true) {
          if (m_bDragged[5])
          {
            //cf.strokeWeight(3);
            //cf.stroke(dragColor);
            cf.fill(cf.slider6);
            cf.ellipse(m_x[5], m_y[5], Psize[5], Psize[5]);
          //  output6.println(cf.index + "\t" + m_x[5] + "\t" + m_y[5] + "\t" + Psize[5] + "\t" + cf.slider6);
          } else
          {
            //cf.fill(cf.slider1);
            //cf.strokeWeight(1);
            //cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[5], m_y[5], Psize[5], Psize[5]);
          //  output6.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
         // cf.index++;
        }




        if (Psize[6]== cf.size[6]&& cf.rec7 == true) {
          if (m_bDragged[6])
          {
            //cf.strokeWeight(3);
            //cf.stroke(dragColor);
            cf.fill(cf.slider7);
            cf.ellipse(m_x[6], m_y[6], Psize[6], Psize[6]);
           // output7.println(cf.index + "\t" + m_x[6] + "\t" + m_y[6] + "\t" + Psize[6] + "\t" + cf.slider7);
          } else
          {
            //cf.fill(cf.slider1);
            //cf.strokeWeight(1);
            //cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[6], m_y[6], Psize[6], Psize[6]);
           // output7.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
         // cf.index++;
        }


        if (Psize[7]== cf.size[7]&& cf.rec8 == true) {
          if (m_bDragged[7])
          {
            //cf.strokeWeight(1);
            //cf.stroke(dragColor);
            cf.fill(cf.slider8);
            cf.ellipse(m_x[7], m_y[7], Psize[7], Psize[7]);
           // output8.println(cf.index + "\t" + m_x[7] + "\t" + m_y[7] + "\t" + Psize[7] + "\t" + cf.slider8);
          } else
          {
            //cf.fill(cf.slider1);
            //cf.strokeWeight(1);
            //cf.stroke(defaultColor);
            cf.fill(0);
            cf.ellipse(m_x[7], m_y[7], Psize[7], Psize[7]);
          //  output8.println(cf.index + "\t" + 0 + "\t" + 0 + "\t" + 0 + "\t" + 0);
          }
          //cf.index++;
        }
      }

      //cf.index++;
      //index0++;
      //println("index0 = " + index0);
    } else if ( cf.playMODE == false ) {

      bri1 = 0; 
      x1 = 0; 
      y1 = 0; 
      size1 = 0; 

      bri2 = 0; 
      x2 = 0; 
      y2 = 0; 
      size2 = 0;
      
      bri3 = 0; 
      x3 = 0; 
      y3 = 0; 
      size3 = 0;
      
      bri4 = 0; 
      x4 = 0; 
      y4 = 0; 
      size4 = 0;
      
      bri5 = 0; 
      x5 = 0; 
      y5 = 0; 
      size5 = 0;
      
      bri6 = 0; 
      x6 = 0; 
      y6 = 0; 
      size6 = 0;
      
      bri7 = 0; 
      x7 = 0; 
      y7 = 0; 
      size7 = 0;
      
      bri8 = 0; 
      x8 = 0; 
      y8 = 0; 
      size8 = 0;

      cf.index = 0;
    }
  }


  void keyPressed() {



    //if(key == ' ' && RECmode == false){
    //  RECmode = true;

    //  println("RECmode true");
    //}else if(key == ' ' && RECmode == true){
    //  RECmode = true;
    //  println("RECmode true");
    //  output.flush(); // Write the remaining data
    //  output.close(); // Finish the file
    //  //exit(); // Stop the program
    //}
    //}
  }
}