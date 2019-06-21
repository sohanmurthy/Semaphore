/********************************************************

SEMAPHORE is an LED art installation located in Coda's
San Francisco Office. It consists of 14 repurposed LED
tubs controlled via custom software that generates organic
shapes and patterns. The installation can be interacted
with remotely via PubNub and suitable endpoints.

 *********************************************************/

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

    new Spirals(lx),
    new Wingbeats(lx),
    new ColorSwatches(lx, 16),
    new Blobs(lx),

    });

  lx.addEffect(effects = new Effects(lx));

  //adds PubNub
  setupPubNubHandlers();

  final LXTransition multiply = new MultiplyTransition(lx).setDuration(4*MINUTES);

  for (LXPattern p : lx.getPatterns()) {
    p.setTransition(multiply);
  }

  lx.enableAutoTransition(17*MINUTES);

  //output = buildOutput();

  // Adds UI elements -- COMMENT all of this out if running on Linux in a headless environment
  size(1280, 720, P3D);
  lx.ui.addLayer(
    new UI3dContext(lx.ui)
    .setCenter(model.cx, model.cy, model.cz)
    .setRadius(10*FEET)
    .setRadiusBounds(2*FEET, 20*FEET)
    .addComponent(pointCloud = new UIPointCloud(lx, model).setPointSize(4))
    );

  lx.ui.addLayer(new UIChannelControl(lx.ui, lx, 0, 0));
  lx.ui.addLayer(new UIEffects(lx.ui, 0, 320));
}


void draw() {
  background(#191919);
}
