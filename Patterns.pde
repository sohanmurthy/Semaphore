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
  
  final int MAX_DOCS = 20;
  final DiscreteParameter docs = new DiscreteParameter("Docs", 10, 1, MAX_DOCS);
  
  
  Spirals(LX lx) {
    super(lx);
    addParameter(docs);
    for (int i = 0; i <= MAX_DOCS; ++i) {
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
Shadows
*******************/


class Shadows extends LXPattern {
  
  final float size = 10;
  final float vLow = 5;
  final float vHigh = 9;
  final int bright = 40;
  final int num = 20;
  
  
  class LeftShadow extends LXLayer {
    
    private final Accelerator xPos = new Accelerator(0, 0, 0);
    private final Accelerator yPos = new Accelerator(0, 0, 0);
     
    LeftShadow(LX lx) {
      super(lx);
      addModulator(xPos).start();
      addModulator(yPos).start();
      init();
    }

    public void run(double deltaMs) {
      boolean touched = false;
      for (LXPoint p : model.points) {
          float b = bright - (bright / size)*dist(p.x/2.2, p.y, xPos.getValuef(), yPos.getValuef());
          float s = b/3;
        if (b > 0) {
          touched = true;
          blendColor(p.index, LXColor.hsb(
            (lx.getBaseHuef() + (p.y / model.yRange) * 67) % 360,
            min(65, (100/s)*abs(p.y - yPos.getValuef())), 
            b), LXColor.Blend.ADD);
        }
      }
      if (!touched) {
        init();
      }
    }

    private void init() {
      xPos.setValue(random(model.xMin-3, model.xMin));
      yPos.setValue(random(model.yMin, model.yMax));  
      xPos.setVelocity(random(vLow, vHigh));
      
    }
  }
  
  class RightShadow extends LXLayer {

    private final Accelerator xPos = new Accelerator(0, 0, 0);
    private final Accelerator yPos = new Accelerator(0, 0, 0);
     
    RightShadow(LX lx) {
      super(lx);
      addModulator(xPos).start();
      addModulator(yPos).start();
      init();
    }

    public void run(double deltaMs) {
      boolean touched = false;
      for (LXPoint p : model.points) {
          float b = bright - (bright / size)*dist(p.x/2, p.y, xPos.getValuef(), yPos.getValuef());
          float s = b/3;
        if (b > 0) {
          touched = true;
          blendColor(p.index, LXColor.hsb(
            (290 + (p.y / model.yRange) * 67) % 360,
            min(65, (100/s)*abs(p.y - yPos.getValuef())), 
            b), LXColor.Blend.ADD);
        }
      }
      if (!touched) {
        init();
      }

    }

    private void init() {
      xPos.setValue(random(model.cx, model.cx+2));
      yPos.setValue(random(model.yMin, model.yMax));  
      xPos.setVelocity(random(-vHigh, -vLow));
      
    }
  }
  
  Shadows(LX lx) {
    super(lx);
    for (int i = 0; i < num; ++i) {
      addLayer(new LeftShadow(lx));
      addLayer(new RightShadow(lx));
      lx.cycleBaseHue(60*MINUTES);
    }
  }

  public void run(double deltaMs) {
    setColors(#000000);
    
  }
    
}



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



class DocStats extends LXPattern {
  
  
  final int MAX_DOCS = 100;
  final DiscreteParameter docs = new DiscreteParameter("Docs", 10, 1, MAX_DOCS);
  
  DocStats(LX lx) {
    super(lx);
    addParameter(docs);
    for (int i = 0; i < MAX_DOCS; ++i) {
      addLayer(new Doc(lx, i));
    }
  }

  class Doc extends LXLayer {
    
    private final SinLFO interval = new SinLFO(7000, 13000, 28000);

    private final Click click = new Click(random(6000, 13000));
    private final QuadraticEnvelope px = new QuadraticEnvelope(0, 0, 0).setEase(QuadraticEnvelope.Ease.BOTH);
    private final QuadraticEnvelope py = new QuadraticEnvelope(0, 0, 0).setEase(QuadraticEnvelope.Ease.BOTH);
      
    private final SinLFO size = new SinLFO(4*INCHES, 10*INCHES, random(6000, 9600));
    private final SinLFO sat = new SinLFO(45, 140, random(6000, 17000));
    
    final int num;

    Doc(LX lx, int num) {
      super(lx);
      this.num = num;
      addModulator(interval).start();
      addModulator(click).start();
      addModulator(px);
      addModulator(py);
      addModulator(size).start();
      addModulator(sat).start();
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
        
        //Squares
      float dx = abs(p.x - px.getValuef());
      float dy = abs(p.y - py.getValuef());
      float b = 100 - (100/size.getValuef()) * max(dx, dy);
      
        if (b > 0) {
          blendColor(p.index, LXColor.hsb(
            //(lx.getBaseHuef() + abs(p.x - model.cx) / model.xRange * 180 + abs(p.y - model.cy) / model.yRange * 180) % 360,
            8,
            min(66, sat.getValuef()), 
            b), LXColor.Blend.ADD
            );
        }
      }
      lx.cycleBaseHue(7.125*MINUTES);
    }

    private void init() {
      px.setRangeFromHereTo(random(model.xMin, model.xMax)).setPeriod(random(3800, 6000)).start();
      py.setRangeFromHereTo(random(model.yMin, model.yMax)).setPeriod(random(3800, 6000)).start();
    }
    
  }

  public void run(double deltaMs) {
    setColors(#000000);
  }
}


class BlobStats extends LXPattern {
  
  
  final int MAX_DOCS = 30;
  final int bright = 60;
  final DiscreteParameter docs = new DiscreteParameter("Docs", 7, 3, MAX_DOCS);
  
  BlobStats(LX lx) {
    super(lx);
    addParameter(docs);
    for (int i = 0; i < MAX_DOCS; ++i) {
      addLayer(new Doc(lx, i));
    }
  }

  class Doc extends LXLayer {
    
    private final SinLFO interval = new SinLFO(7000, 13000, 28000);

    //private final Click click = new Click(random(6000, 13000));
    private final Click click = new Click(interval);
    private final QuadraticEnvelope px = new QuadraticEnvelope(0, 0, 0).setEase(QuadraticEnvelope.Ease.BOTH);
    private final QuadraticEnvelope py = new QuadraticEnvelope(0, 0, 0).setEase(QuadraticEnvelope.Ease.BOTH);
      
    private final SinLFO size = new SinLFO(4*INCHES, 10*INCHES, random(6000, 9600));
    
    final int num;

    Doc(LX lx, int num) {
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
            (lx.getBaseHuef() + (p.y / model.yRange) * 67) % 360,
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



class PatternTest extends LXPattern {
  
 
  private final SinLFO speed = new SinLFO(2600, 4800, 16000);
  private final SawLFO move = new SawLFO(TWO_PI, 0, speed);
  private final SinLFO tight = new SinLFO(36, 16, 18000);
  private final SinLFO hr = new SinLFO(90, 300, 25000);
  
  
  PatternTest(LX lx) {
    super(lx);
    addModulator(hr).start();
    addModulator(tight).start();
    addModulator(speed).start();
    addModulator(move).start();

  }
  
  public void run(double deltaMs) {
    for (LXPoint p : model.points) {
     
      
      //"+" or "-" before move function changes direction
      float dx = (dist(p.x, p.y, model.xMax, model.cy)) / model.xRange;
      float b = 50 + 50 * sin(dx * tight.getValuef() + move.getValuef());
      
      colors[p.index] = LXColor.hsb(
      (lx.getBaseHuef() + max(abs(p.x - model.cx), abs(p.y - model.cy)) / model.xRange * hr.getValuef()) % 360,
      65,
      b);

    }
    
  lx.cycleBaseHue(6*MINUTES);
    
  }
}


/************

Interference

*************/

class Interference extends LXPattern {

      class Concentric extends LXLayer{

        private final SinLFO sync = new SinLFO(13*SECONDS,21*SECONDS, 34*SECONDS);
        private final SinLFO speed = new SinLFO(7700,3200, sync);
        private final SinLFO tight = new SinLFO(10,15, sync);

        private final TriangleLFO cy = new TriangleLFO(model.yMin, model.yMax, random(2*MINUTES+sync.getValuef(),3*MINUTES+sync.getValuef()));
        private final SawLFO move = new SawLFO(TWO_PI, 0, speed);
        
        private final TriangleLFO hue = new TriangleLFO(0,88, sync);

        private final float cx;
        private final int slope = 25;

        Concentric(LX lx, float x){
        super(lx);
        cx = x;
        addModulator(sync.randomBasis()).start();
        addModulator(speed.randomBasis()).start();
        addModulator(tight.randomBasis()).start();
        addModulator(move.randomBasis()).start();
        addModulator(hue.randomBasis()).start();
        addModulator(cy.randomBasis()).start();
        }

         public void run(double deltaMs) {
           for(LXPoint p : model.points) {
           float dx = (dist(p.x, p.y, cx, cy.getValuef()))/ slope;
           float ds = (dist(p.x, p.y, cx, cy.getValuef()))/ (slope/1.1);
           float b = 12 + 12 * sin(dx * tight.getValuef() + move.getValuef());
           float s = 50 + 50 * sin(ds * tight.getValuef()/1.3 + move.getValuef());;
             blendColor(p.index, LXColor.hsb(
             lx.getBaseHuef()+hue.getValuef(),
             
             s,
             b
             ), LXColor.Blend.ADD);
           }
         }
      }

  Interference(LX lx){
    super(lx);
    addLayer(new Concentric(lx, model.xMin));
    addLayer(new Concentric(lx, model.cx));
    addLayer(new Concentric(lx, model.xMax));
  }

  public void run(double deltaMs) {
    setColors(#000000);
    lx.cycleBaseHue(7.86*MINUTES);
  }

}
