
class UIEffects extends UIControlBucket {
  UIEffects(UI ui, float x, float y) {
    super(ui, "EFFECTS", x, y, UIChannelControl.WIDTH);
    addButton(effects.wipeRadial).setLabel("WipeR").setMomentary(true);
    addButton(effects.wipeVert).setLabel("WipeV").setMomentary(true);
    addButton(effects.wipeHoriz).setLabel("WipeH").setMomentary(true);
    addKnob(effects.wipeDecay).setLabel("Dcy");
  }
}




//UI element definitions (buttons, knobs, toggles, etc.)
abstract class UIControlBucket extends UIWindow {
  
  private float xSpacing = 34;
  private float ySpacing = 48;
  private float xIndent = 4;
  private float yIndent = 8;
  
  private float xp = xIndent;
  private float yp = UIWindow.TITLE_LABEL_HEIGHT;
  
  private boolean inRow = false;;
  
  protected UIControlBucket(UI ui, String title, float x, float y) {
    this(ui, title, x, y, UIChannelControl.WIDTH);
  }
  
  protected UIControlBucket(UI ui, String title, float x, float y, float w) {
    this(ui, title, x, y, w, 0);
  }
  
  protected UIControlBucket(UI ui, String title, float x, float y, float w, float h) {
    super(ui, title, x, y, w, h);
  }
  
  public UIControlBucket setXSpacing(float xSpacing) {
    this.xSpacing = xSpacing;
    return this;
  }
  
  public UIControlBucket setYSpacing(float ySpacing) {
    this.ySpacing = ySpacing;
    return this;
  }
  
  public UIControlBucket setXIndent(float xIndent) {
    this.xIndent = xIndent;
    return this;
  }
  
  private void checkHeight() {
    if (this.yp >= this.height) {
      setSize(this.width, this.yp + this.ySpacing);
    }
  }
  
  protected UIKnob addKnob(LXListenableNormalizedParameter parameter) {
    checkHeight();
    UIKnob knob = new UIKnob(this.xp, this.yp);
    knob.setParameter(parameter).addToContainer(this);
    this.xp += this.xSpacing;
    this.inRow = true;
    if (xp >= this.width - 10) {
      endRow(); 
    }
    return knob;
  }
  
  protected UIControlBucket endRow() {
    if (this.inRow) {
      this.xp = this.xIndent;
      this.yp += this.ySpacing;
      this.inRow = false;
    }
    return this;
  }
  
  protected UIControlBucket addComponent(UI2dComponent component) {
    if (this.height < this.yp + component.getHeight()) {
      setSize(this.width, this.yp + component.getHeight() + this.yIndent);
    }
    component.addToContainer(this);
    this.yp += component.getHeight() + this.yIndent;
    return this;
  }
  
  protected UIColorSwatch addColorSwatch(LXPalette palette) {
    endRow();
    UIColorSwatch swatch = new UIColorSwatch(palette, this.xIndent, this.yp, this.width - 2*this.xIndent, 32);
    addComponent(swatch);
    return swatch;
  }
  
  protected UIToggleSet addToggleSet(DiscreteParameter parameter) {
    endRow();
    UIToggleSet toggle = new UIToggleSet(this.xIndent, this.yp, this.width - 2*this.xIndent, 24);
    toggle.setEvenSpacing().setParameter(parameter); 
    addComponent(toggle);
    return toggle;
  }
  
  protected UIButton addButton(BooleanParameter parameter) {
    endRow();
    UIButton button = new UIButton(this.xIndent, this.yp, this.width - 2*this.xIndent, 20);
    button.setParameter(parameter).setLabel(parameter.getLabel());
    addComponent(button);
    return button;
  }
  
  protected UISlider addSlider(LXListenableNormalizedParameter parameter) {
    endRow();
    UISlider slider = new UISlider(this.xIndent, this.yp, this.width - 2*this.xIndent, 20);
    slider.setParameter(parameter).setLabel(parameter.getLabel());
    addComponent(slider);
    return slider;
  }
}
