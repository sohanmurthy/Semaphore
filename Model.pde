//Defines the model with a few parameters for tube size/pixel density and orientation
// 0.65625 inches between pixels = 60 LEDs per meter
// 1.325 inches between pixels = 30 LEDs per meter

public static final int TUBE_PIXELS = 64;
public static final float PIXEL_SPACING = 0.65625;
public static final int TUBE_YPOS = 6;
public static final int TUBE_OFFSET = 56;


static class Model extends LXModel {
  
  Model() {
    super(new Fixture());
  }
  
  private static class Fixture extends LXAbstractFixture {
      
    Fixture(){
     
     addPoints(new Tube(0,TUBE_YPOS*0)); 
     addPoints(new Tube(-12,TUBE_YPOS*1));
     addPoints(new Tube(-26,TUBE_YPOS*2));
     addPoints(new Tube(-34,TUBE_YPOS*3));
     addPoints(new Tube(-34,TUBE_YPOS*4));
     addPoints(new Tube(-26,TUBE_YPOS*5));
     addPoints(new Tube(-12,TUBE_YPOS*6));
     addPoints(new Tube(0,TUBE_YPOS*7));
     
     addPoints(new Tube(-TUBE_OFFSET,TUBE_YPOS*0)); 
     addPoints(new Tube(-TUBE_OFFSET-12,TUBE_YPOS*1));
     addPoints(new Tube(-TUBE_OFFSET-26,TUBE_YPOS*2));
     addPoints(new Tube(-TUBE_OFFSET-34,TUBE_YPOS*3));
     addPoints(new Tube(-TUBE_OFFSET-34,TUBE_YPOS*4));
     addPoints(new Tube(-TUBE_OFFSET-26,TUBE_YPOS*5));
     addPoints(new Tube(-TUBE_OFFSET-12,TUBE_YPOS*6));
     addPoints(new Tube(-TUBE_OFFSET,TUBE_YPOS*7));
     
     
     //half-wing
     addPoints(new TubeRight(43,TUBE_YPOS*1));
     addPoints(new TubeRight(51,TUBE_YPOS*2));
     addPoints(new TubeRight(54,TUBE_YPOS*3));
     addPoints(new TubeRight(54,TUBE_YPOS*4));
     addPoints(new TubeRight(51,TUBE_YPOS*5));
     addPoints(new TubeRight(43,TUBE_YPOS*6));
     
    }
    
 }
 
}


//Tubes that are oriented right-to-left
static class Tube extends LXAbstractFixture {
    
    private Tube(int xP, int yP) {
      for (int x = TUBE_PIXELS; x > 0 ; --x) {
            addPoint(new LXPoint(xP+x*PIXEL_SPACING, yP));          
      }
    }
    
}


//Tubes that are oriented left-to-right
static class TubeRight extends LXAbstractFixture {
    
    private TubeRight(int xP, int yP) {
      for (int x = 0; x < TUBE_PIXELS ; ++x) {
            addPoint(new LXPoint(xP+x*PIXEL_SPACING, yP));          
      }
    }
    
}
