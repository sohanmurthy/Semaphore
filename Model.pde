//Defines the model with a few parameters for tube size/pixel density and orientation
// 0.65625 inches between pixels = 60 LEDs per meter
// 1.325 inches between pixels = 30 LEDs per meter

public static final int TUBE_PIXELS = 64;
public static final float PIXEL_SPACING = 0.65625;
public static final int TUBE_YPOS = 6;
public static final int TUBE_XPOS = 15;
public static final int TUBE_OFFSET = 18;


static class Model extends LXModel {

  Model() {
    super(new Fixture());
  }

  private static class Fixture extends LXAbstractFixture {

    Fixture() {
      //angled tubes with an offset
      for (int i = 0; i < 7; i++) {
        addPoints(new TubeAngle((TUBE_XPOS*i)+TUBE_YPOS, TUBE_YPOS, 50));
        addPoints(new TubeAngle((TUBE_XPOS*i)+(8), 0, 50));
      }
      
    }
  }
}


//Tubes that are oriented left-to-right at a specified angle (theta)
static class TubeAngle extends LXAbstractFixture {

  private TubeAngle(int xP, int yP, int theta) {
    for (int i = 0; i < TUBE_PIXELS; ++i) {
      addPoint(
        new LXPoint(xP+i*(PIXEL_SPACING*cos(radians(theta))), yP+i*(PIXEL_SPACING*sin(radians(theta)))
        )
      );
    }
  }
}
