/********************************************************

Exploration of model construction and effects triggers
for a potential installation at Coda's 340 Branna office

*********************************************************/

//import ddf.minim.*;

final static int INCHES = 1;
final static int FEET = 12*INCHES;
final static int SECONDS = 1000;
final static int MINUTES = 60*SECONDS;

Model model;
P3LX lx;
LXOutput output;
UI3dComponent pointCloud;
Effects effects;

void setup() {

  model = new Model();
  lx = new P3LX(this, model);

  lx.setPatterns(new LXPattern[] {
    
    new BlobStats(lx),
    new Aurora(lx),
    new Spirals(lx),
    new ColorSwatches(lx, 32),
    new ColorSwatches(lx, 16),

    new IteratorTestPattern(lx),
    //new BaseHuePattern(lx),

  });
  
  lx.addEffect(effects = new Effects(lx));
  
  final LXTransition multiply = new MultiplyTransition(lx).setDuration(5*SECONDS);

  for (LXPattern p : lx.getPatterns()) {
    p.setTransition(multiply);
  }

  //lx.enableAutoTransition(3*MINUTES);

  //output = buildOutput();

  // Adds UI elements -- COMMENT all of this out if running on Linux in a headless environment
  size(1280, 720, P3D);
  lx.ui.addLayer(
    new UI3dContext(lx.ui)
    .setCenter(model.cx, model.cy, model.cz)
    .setRadius(10*FEET)
    .setRadiusBounds(2*FEET, 20*FEET)
    //.setTheta(PI/6)
    //.setPhi(PI/64)
    .addComponent(pointCloud = new UIPointCloud(lx, model).setPointSize(4))
  );
  
  lx.ui.addLayer(new UIChannelControl(lx.ui, lx, 0, 0));
  lx.ui.addLayer(new UIEffects(lx.ui, 0, 320));

}


void draw() {
  background(#191919);
}
