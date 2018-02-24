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

  void add(Handle h)
  {
    m_handles.add(h);

    hh = h;

    for(int i=0; i < cf.HANDLE_NB; i++){
      h.m_x[i] = cf.width/2;
      h.m_y[i] = cf.moniterY+height/2;
    }
      //println("m_handles.add(h)");
    }

    void update()
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