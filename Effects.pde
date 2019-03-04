class Effects extends LXEffect {
  
  final BoundedParameter wipeDecay = new BoundedParameter("WipDcy", 2000, 100, 4000);
  
  final Wipe[] wipes;
  final int MAX_WIPES = 10;
  
  final BooleanParameter wipeHoriz = new BooleanParameter("wipeHoriz", false);
  final BooleanParameter wipeRadial = new BooleanParameter("wipeRadial", false);
  final BooleanParameter wipeVert = new BooleanParameter("wipeVert", false);
  
  Effects(LX lx) {
    super(lx);
     
    wipes = new Wipe[MAX_WIPES];
    for (int i = 0; i < wipes.length; ++i) {
      addLayer(wipes[i] = new Wipe(lx));
    }
    
    wipeHoriz.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter p) {
        if (wipeHoriz.isOn()) {
          triggerWipe(random(0, 1) > 0.5 ? 0 : 1);
        }
      }
    });
    wipeRadial.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter p) {
        if (wipeRadial.isOn()) {
          triggerWipe(4);
        }
      }
    });
    wipeVert.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter p) {
        if (wipeVert.isOn()) {
          triggerWipe(random(0, 1) > 0.5 ? 2 : 3);
        }
      }
    });
      
  }
  
  void triggerWipe(int dir) {
    for (Wipe w : wipes) {
      if (!w.pos.isRunning()) {
        w.trigger(dir);
        break;
      }
    }
  }
  
  public void run(double deltaMs) {
    
  }
  
 
  
  class Wipe extends LXLayer {
    final LinearEnvelope pos = new LinearEnvelope(0, 1, wipeDecay);
    
    private int direction = 0;
    private float cx = model.cy;
    private float cy = model.cx;
    
    Wipe(LX lx) {
      super(lx);
      addModulator(pos);
    }
    
    void trigger(int dir) {
      direction = dir;
      cx = model.cx + random(-4*FEET, 4*FEET);
      cy = model.cy + random(-4*FEET, 4*FEET);
      pos.trigger();
    }
    
    public void run(double deltaMs) {
      if (!pos.isRunning()) {
        return;
      }
      float pv = 0;
      float pvf = 1 - (1-pos.getValuef())*(1-pos.getValuef());
      switch (direction) {
        case 0: pv = lerp(model.xMin, model.xMax, pvf); break;
        case 1: pv = lerp(model.xMax, model.xMin, pvf); break;
        case 2: pv = lerp(model.yMin, model.yMax, pvf); break;
        case 3: pv = lerp(model.yMax, model.yMin, pvf); break;
        case 4: pv = pvf * .7*model.xRange; break;
      }
      
      for (LXPoint p : model.points) {
        float dist = 0;
        switch (direction) {
          case 0:
          case 1:
            dist = abs(p.x - pv); break;
          case 2:
          case 3:
            dist = abs(p.y - pv); break;
          case 4:
            dist = abs(dist(p.x, p.y, cx, cy) - pv); break;
        }
        float b = min(1, 2-2*pos.getValuef()) * (100 - 10*dist);
        if (b > 0) {
            blendColor(p.index, LXColor.hsb(
            lx.getBaseHuef(),
            50, 
            b), LXColor.Blend.ADD);
        }
      }
      lx.cycleBaseHue(3*SECONDS);
    }
    
  }
 
}
