//Defines the model with a few parameters for tube size/pixel density and orientation
// 0.65625 inches between pixels = 60 LEDs per meter
// 1.325 inches between pixels = 30 LEDs per meter

public static final int TUBE_PIXELS = 64;
public static final float PIXEL_SPACING = 0.65625;
public static final int TUBE_YPOS = 6;
public static final int TUBE_XPOS = 18;
public static final int TUBE_OFFSET = 18;


static class Model extends LXModel {

  Model() {
    super(new Fixture());
  }

  private static class Fixture extends LXAbstractFixture {

    Fixture() {

      //angled tubes with an offsent
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
