//Defines the model with a few parameters for tube size/pixel density and orientation
// 0.65625 inches between pixels = 60 LEDs per meter
// 1.325 inches between pixels = 30 LEDs per meter

/*
SIMPLE
  set TUBE_YPOS = 6
      TUBE_XPOS = 18

STAIRSTEP
  set TUBE_YPOS = 6
      TUBE_XPOS = 36
      TUBE_XOFFSET = 9
      TUBE_YOFFSET = -3

CROSSHATCH
  set TUBE_YPOS = 6
      TUBE_XPOS = 36
      TUBE_XOFFSET = 9
      TUBE_YOFFSET = 12
*/

public static final int TUBE_PIXELS = 64;
public static final float PIXEL_SPACING = 0.65625;

public static final int TUBE_YPOS = 6;
public static final int TUBE_XPOS = 36;
public static final int TUBE_XOFFSET = 9;
public static final int TUBE_YOFFSET = -3;


static class ComplexModel extends LXModel {

  ComplexModel() {
    super(new Fixture());
  }

  private static class Fixture extends LXAbstractFixture {

    Fixture() {

      for (int i = 0; i < 4; i++) {
        addPoints(new TubeAngle((TUBE_XPOS*i)+TUBE_YPOS, TUBE_YPOS));
        addPoints(new TubeAngle((TUBE_XPOS*i)+(TUBE_XPOS/2), 0));
      }

      for (int i = 0; i < 4; i++) {
        addPoints(new TubeAngle((TUBE_XPOS*i)+TUBE_YPOS+TUBE_XOFFSET+TUBE_YOFFSET, TUBE_YPOS+TUBE_YOFFSET));
        addPoints(new TubeAngle((TUBE_XPOS*i)+(TUBE_XPOS/2)+TUBE_XOFFSET+TUBE_YOFFSET, TUBE_YOFFSET));
      }
 
    }
  }
}


static class SimpleModel extends LXModel {

  SimpleModel() {
    super(new Fixture());
  }

  private static class Fixture extends LXAbstractFixture {

    Fixture() {


      for (int i = 0; i < 8; i++) {
        addPoints(new TubeAngle((TUBE_XPOS*i)+TUBE_YPOS, TUBE_YPOS));
        addPoints(new TubeAngle((TUBE_XPOS*i)+(TUBE_XPOS/2), 0));
      }    
      
    }
  }
}





//Tubes that are oriented left-to-right in a 45 degree angle
static class TubeAngle extends LXAbstractFixture {

  private TubeAngle(int xP, int yP) {
    for (int i = 0; i < TUBE_PIXELS; ++i) {
      addPoint(new LXPoint(xP+i*(sqrt(pow(PIXEL_SPACING, 2)/2)), yP+i*(sqrt(pow(PIXEL_SPACING, 2)/2))));
    }
  }
}


static class TubeRight extends LXAbstractFixture {

  private TubeRight(int xP, int yP) {
    for (int x = 0; x < TUBE_PIXELS; ++x) {
      addPoint(new LXPoint(xP+x*PIXEL_SPACING, yP));
    }
  }
}



static class TubeLeft extends LXAbstractFixture {

  private TubeLeft(int xP, int yP) {
    for (int x = TUBE_PIXELS; x > 0; --x) {
      addPoint(new LXPoint(xP+x*PIXEL_SPACING, yP));
    }
  }
}
