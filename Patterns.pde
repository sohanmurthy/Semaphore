/******************
Color Swatches
*******************/

class ColorSwatches extends LXPattern{
  

  class Swatch extends LXLayer {

    private final SinLFO sync = new SinLFO(8*SECONDS, 14*SECONDS, 39*SECONDS);
    private final SinLFO bright = new SinLFO(-80,100, sync);
    private final SinLFO sat = new SinLFO(35,55, sync);
    private final TriangleLFO hueValue = new TriangleLFO(0, 44, sync);

    private int sPixel;
    private int fPixel;
    private float hOffset;

    Swatch(LX lx, int s, int f, float o){
      super(lx);
      sPixel = s;
      fPixel = f;
      hOffset = o;
      addModulator(sync.randomBasis()).start();
      addModulator(bright.randomBasis()).start();
      addModulator(sat.randomBasis()).start();
      addModulator(hueValue.randomBasis()).start();
    }

    public void run(double deltaMs) {
      float s = sat.getValuef();
      float b = constrain(bright.getValuef(), 0, 100);

      for(int i = sPixel; i < fPixel; i++){
        blendColor(i, LXColor.hsb(
          lx.getBaseHuef() + hueValue.getValuef() + hOffset,
          //lx.getBaseHuef() + hOffset,
          s,
          b
          ), LXColor.Blend.LIGHTEST);
        }
    }

  }

  ColorSwatches(LX lx, int num_sec){
   super(lx);
   //size of each swatch in pixels
    final int section = num_sec;
   for(int s = 0; s <= model.size-section; s+=section){
     if((s+section) % (section*2) == 0){
     addLayer(new Swatch(lx, s, s+section, 28));
     }else{
       addLayer(new Swatch(lx, s, s+section, 0));
     }  
   }
  }

  public void run(double deltaMs) {
    setColors(#000000);
    lx.cycleBaseHue(3.37*MINUTES);
  }

}



/******************
Spirals
*******************/

class Spirals extends LXPattern {
  
  final int MAX_SPIRALS = 12;
  final DiscreteParameter docs = new DiscreteParameter("Num", 6, 1, MAX_SPIRALS);
  
  
  Spirals(LX lx) {
    super(lx);
    addParameter(docs);
    for (int i = 0; i <= MAX_SPIRALS; ++i) {
      addLayer(new Wave(lx, i*6, i));
    }
  }
  
  class Wave extends LXLayer {
    
    final private SinLFO rate1 = new SinLFO(200000*2, 290000*2, 17000);
    final private SinLFO off1 = new SinLFO(-4*TWO_PI, 4*TWO_PI, rate1);
    final private SinLFO wth1 = new SinLFO(7, 12, 30000);

    final private SinLFO rate2 = new SinLFO(228000*1.6, 310000*1.6, 22000);
    final private SinLFO off2 = new SinLFO(-4*TWO_PI, 4*TWO_PI, rate2);
    final private SinLFO wth2 = new SinLFO(15, 20, 44000);

    final private SinLFO rate3 = new SinLFO(160000, 289000, 14000);
    final private SinLFO off3 = new SinLFO(-2*TWO_PI, 2*TWO_PI, rate3);
    final private SinLFO wth3 = new SinLFO(12, 140, 40000);

    final private float hOffset;
    
    final int num;
    
    Wave(LX lx, float o, int num) {
      super(lx);
      hOffset = o;
      this.num = num;
      addModulator(rate1.randomBasis()).start();
      addModulator(rate2.randomBasis()).start();
      addModulator(rate3.randomBasis()).start();
      addModulator(off1.randomBasis()).start();
      addModulator(off2.randomBasis()).start();
      addModulator(off3.randomBasis()).start();
      addModulator(wth1.randomBasis()).start();
      addModulator(wth2.randomBasis()).start();
      addModulator(wth3.randomBasis()).start();
    }

    public void run(double deltaMs) {
      if (this.num > docs.getValuei()) {
        return;
      }
      for (LXPoint p : model.points) {
        
        float vy1 = model.yRange/4 * sin(off1.getValuef() + (p.x - model.cx) / wth1.getValuef());
        float vy2 = model.yRange/4 * sin(off2.getValuef() + (p.x - model.cx) / wth2.getValuef());
        float vy = model.ay + vy1 + vy2;
        
        float thickness = 4 + 2 * sin(off3.getValuef() + (p.x - model.cx) / wth3.getValuef());
        float ts = thickness/1.2;

        blendColor(p.index, LXColor.hsb(
        ((lx.getBaseHuef()+190) + hOffset + (p.x / model.xRange) * 90) % 360,
        min(65, (100/ts)*abs(p.y - vy)), 
        max(0, 40 - (40/thickness)*abs(p.y - vy))
        ), LXColor.Blend.ADD);
      }
    }
   
  }


  public void run(double deltaMs) {
    setColors(#000000);
    lx.cycleBaseHue(5.42*MINUTES);
  }
}


/******************
Aurora
*******************/

class Aurora extends LXPattern {
  class Wave extends LXLayer {
    
    final private SinLFO rate1 = new SinLFO(200000, 290000, 17000);
    final private SinLFO off1 = new SinLFO(-4*TWO_PI, 4*TWO_PI, rate1);
    final private SinLFO wth1 = new SinLFO(7, 12, 30000);

    final private SinLFO rate2 = new SinLFO(228000, 310000, 22000);
    final private SinLFO off2 = new SinLFO(-4*TWO_PI, 4*TWO_PI, rate2);
    final private SinLFO wth2 = new SinLFO(15, 20, 44000);

    final private SinLFO rate3 = new SinLFO(160000, 289000, 14000);
    final private SinLFO off3 = new SinLFO(-2*TWO_PI, 2*TWO_PI, rate3);
    final private SinLFO wth3 = new SinLFO(12, 140, 40000);


    Wave(LX lx) {
      super(lx);      
      addModulator(rate1.randomBasis()).start();
      addModulator(rate2.randomBasis()).start();
      addModulator(rate3.randomBasis()).start();
      addModulator(off1.randomBasis()).start();
      addModulator(off2.randomBasis()).start();
      addModulator(off3.randomBasis()).start();
      addModulator(wth1.randomBasis()).start();
      addModulator(wth2.randomBasis()).start();
      addModulator(wth3.randomBasis()).start();
    }

    public void run(double deltaMs) {
      for (LXPoint p : model.points) {
        
        float vy1 = model.yRange/5 * sin(off1.getValuef() + (p.x - model.cx) / wth1.getValuef());
        float vy2 = model.yRange/5 * sin(off2.getValuef() + (p.x - model.cx) / wth2.getValuef());
        float vy = model.ay + vy1 + vy2;
        
        float thickness = 16 + 7 * sin(off3.getValuef() + (p.x - model.cx) / wth3.getValuef());
        float ts = thickness/1.2;

        addColor(p.index, LXColor.hsb(
        (lx.getBaseHuef() + (p.x / model.xRange) * 66) % 360,
        min(65, (100/ts)*abs(p.y - vy)), 
        max(0, 100 - (100/thickness)*abs(p.y - vy))
        ));
      }
    }
   
  }

  Aurora(LX lx) {
    super(lx);
    for (int i = 0; i < 1; ++i) {
      addLayer(new Wave(lx));
    }
  }

  public void run(double deltaMs) {
    setColors(#000000);
    lx.cycleBaseHue(6.34*MINUTES);
  }
}



/******************
Blobs
*******************/

class Blobs extends LXPattern {
  
  
  final int MAX_BLOBS = 30;
  final int bright = 80;
  final DiscreteParameter docs = new DiscreteParameter("Num", 7, 3, MAX_BLOBS);
  
  Blobs(LX lx) {
    super(lx);
    addParameter(docs);
    for (int i = 0; i < MAX_BLOBS; ++i) {
      addLayer(new Blob(lx, i));
    }
  }

  class Blob extends LXLayer {
    
    private final SinLFO interval = new SinLFO(7000, 13000, 28000);

    //private final Click click = new Click(random(6000, 13000));
    private final Click click = new Click(interval);
    private final QuadraticEnvelope px = new QuadraticEnvelope(0, 0, 0).setEase(QuadraticEnvelope.Ease.BOTH);
    private final QuadraticEnvelope py = new QuadraticEnvelope(0, 0, 0).setEase(QuadraticEnvelope.Ease.BOTH);
      
    private final SinLFO size = new SinLFO(4*INCHES, 10*INCHES, random(6000, 9600));
    
    final int num;

    Blob(LX lx, int num) {
      super(lx);
      this.num = num;
      addModulator(interval).start();
      addModulator(click).start();
      addModulator(px);
      addModulator(py);
      addModulator(size).start();
      init();
    }

    public void run(double deltaMs) {
      if (click.click()) {
        init();
      }   
      if (this.num > docs.getValuei()) {
        return;
      }    
      for (LXPoint p : model.points) {
        
        float b = bright - (bright / size.getValuef())*dist(p.x/2.2, p.y, px.getValuef(), py.getValuef());
        float s = b/3;

        if (b > 0) {
          blendColor(p.index, LXColor.hsb(
            (lx.getBaseHuef() + (p.y / model.yRange) * 90) % 360,
            min(65, (100/s)*abs(p.y - py.getValuef())), 
            b), LXColor.Blend.ADD);
        }
      }
      lx.cycleBaseHue(7.125*MINUTES);
    }

    private void init() {
      px.setRangeFromHereTo(random(model.xMin, model.cx)).setPeriod(random(3800, 6000)).start();
      py.setRangeFromHereTo(random(model.yMin, model.yMax)).setPeriod(random(3800, 6000)).start();
    }
    
  }

  public void run(double deltaMs) {
    setColors(#000000);
  }
}



/******************
Wingbeats
*******************/

class Wingbeats extends LXPattern {
      
  Wingbeats(LX lx) {
    super(lx);
    
    for (int i = 0; i < 3; ++i) {
      addLayer(new Wing(lx, i*40));
    }
  }
  
  public void run(double deltaMs) {
    LXColor.scaleBrightness(colors, max(0, (float) (1 - deltaMs / 600.f)), null);
  }
  
  class Wing extends LXLayer {
    
    private final SinLFO interval = new SinLFO(10*SECONDS, 12*SECONDS, 5*MINUTES);
    private final Click switchBeat = new Click(interval);

    private final int hOffset;
    
    private final SinLFO xPeriod  = new SinLFO (random(30*SECONDS, 40*SECONDS), random(50*SECONDS, 60*SECONDS), random(40*SECONDS, 80*SECONDS));
    
    private final SinLFO wingCenterX = new SinLFO(model.xMin+10, model.xMax-10, xPeriod);

    private final SinLFO wingCenterY = new SinLFO(model.cy+5, model.cy-5, 1000);
     
    private final SinLFO wingTipY = new SinLFO(model.yMin, model.yMax, 1000);
    
    private final SinLFO wingLength = new SinLFO(20, 40, 5000);
    
    Wing(LX lx, int h) {
      super(lx);
      hOffset = h;
      addModulator(interval).start();
      addModulator(switchBeat).start();     
      addModulator(xPeriod.randomBasis()).start();
      addModulator(wingCenterX.randomBasis()).start();
      startModulator(wingCenterY);
      addModulator(wingLength.randomBasis()).start();
      addModulator(wingTipY).start();
      init();
    }

    private void init() {
      final float ds = random(5000,9000);
      wingCenterY.setPeriod(ds);
      wingTipY.setPeriod(ds);
      wingLength.setPeriod(ds/2);
    }
    
    private void line(float x1, float y1, float x2, float y2) {
      float xt, yt;
      if (x1 > x2) {
        xt = x2; x2 = x1; x1 = xt;
        yt = y2; y2 = y1; y1 = yt;
      }
      float EDGE = 40;
      float LIP = 20;
      float FADE = 10;
      
      for (LXPoint p : model.points) {
        if (p.x >= (x1-EDGE) && p.x <= (x2+EDGE)) {
          float yv = lerp(y1, y2, (p.x-x1) / (x2-x1));
          float b = min(100, min(LIP*(p.x-x1), LIP*(x2-p.x)));          
          b = b - FADE*abs(p.y - yv);
          float s = b/3 - FADE*abs(p.y - yv);
          if (b > 0) {
            blendColor(p.index, LXColor.hsb(
            lx.getBaseHuef() + hOffset,
            min(100, abs(s)), 
            b), LXColor.Blend.LIGHTEST);
          }
        }
      }
      if (y1 > y2) {
        xt = x2; x2 = x1; x1 = xt;
        yt = y2; y2 = y1; y1 = yt;
      }
      for (LXPoint p : model.points) {
        if (p.y >= (y1-EDGE) && p.y <= (y2+EDGE)) {
          float xv = lerp(x1, x2, (p.y - y1) / (y2-y1));
          float b = min(100, min(LIP*(p.y-y1), LIP*(y2-p.y)));
          b = b - FADE*abs(p.x - xv);
          float s = b/3 - FADE*abs(p.x - xv);
          if (b > 0) {
            blendColor(p.index, LXColor.hsb(
            lx.getBaseHuef() + hOffset,
            min(100, abs(s)), 
            b), LXColor.Blend.LIGHTEST);
          }
        }
      }
    }
    
    public void run(double deltaMs) {
      
      if (switchBeat.click()) {
        init();
      } 
           

      float x1 = wingCenterX.getValuef()-wingLength.getValuef();
      float y1 = wingTipY.getValuef();
      float x2 = wingCenterX.getValuef();
      float y2 = wingCenterY.getValuef();
      float x3 = wingCenterX.getValuef()+wingLength.getValuef();
      float y3 = wingTipY.getValuef();
      
      line(x1, y1, x2, y2);
      line(x2, y2, x3, y3);
     
    }
    
  }
}
