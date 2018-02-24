import java.util.Date;
import java.util.Map;


///////////////////////////////////////////////////////////////////////////////

class HUDisp {
  HashMap<String, String> items = new HashMap<String, String>();
  PFont dispFont;  // TODO: Should be static (global?)
  HashMap<String, Object> sliders = new HashMap<String, Object>();
  HashMap<String, Object> checkboxes = new HashMap<String, Object>();
  boolean displayEnabled;

  HUDisp() {
    dispFont = loadFont("OCRAStd-10.vlw");
    textFont(dispFont);
    displayEnabled = false;
  }

  void toggleDisplay() {
    displayEnabled = !displayEnabled;
  }

  void addSlider(String label) {
    sliders.put(label, new HSlider(240, 17*(sliders.size() + 1), 100, 10));
  }

  void addCheckbox(String label, boolean initState) {
    HCheckbox cb = new HCheckbox(label, 80, 17*(checkboxes.size() + 1), 10, 10, initState);
    //checkboxes.put(label, new HCheckbox(240, 17*(sliders.size() + checkboxes.size() + 1), 10, 10, initState));
    checkboxes.put(label, cb);
  }

  void updateItem(String label, String val) {
    items.put(label, val);
  }

  void update() {
    for (Map.Entry slider : sliders.entrySet()) {
      HSlider sl = (HSlider)slider.getValue();
      sl.update();
    }

    for (Map.Entry checkbox : checkboxes.entrySet()) {
      HCheckbox cb = (HCheckbox)checkbox.getValue();
      cb.update();
    }
  }

  void draw() {
    if (!displayEnabled) {
      return;
    }
    noStroke();
    fill(0xAADDDDDD);
    rect(5, 5, 350, 120);
    fill(#666666);
    int i = 1;
    for (Map.Entry item : items.entrySet()) {
      text(item.getKey() + ": " + item.getValue(), 10, 17*i);
      i += 1;
    }

    i = 1;
    for (Map.Entry slider : sliders.entrySet()) {
      fill(#666666);
      HSlider sl = (HSlider)slider.getValue();
      String label = (String)slider.getKey();
      text(label, 180, 18*i);
      sl.draw();
      i += 1;
    }

    //i = 1;
    for (Map.Entry checkbox : checkboxes.entrySet()) {
      fill(#666666);
      HCheckbox cb = (HCheckbox)checkbox.getValue();
      //String label = (String)checkbox.getKey();
      //text(label, 180, 18*i);
      cb.draw();
      i += 1;
    }
  }

  void checkClick() {
    int cmouseX = mouseX;
    int cmouseY = mouseY;

    for (Map.Entry checkbox : checkboxes.entrySet()) {
      HCheckbox cb = (HCheckbox)checkbox.getValue();
      if (cb.checkClick(cmouseX, cmouseY) == true) {
        String label = (String)checkbox.getKey();
        println("Clicked: ", label, " = ", cb.getState());
        return;
      }
    }
  }
}


///////////////////////////////////////////////////////////////////////////////

// Derived from https://processing.org/examples/scrollbar.html
class HSlider {
  int wSz, hSz;
  float xPos, yPos;
  float slPos, newSlPos;
  float slPosMin, slPosMax;
  boolean hover;
  boolean locked;
  float ratio;

  HSlider (float xp, float yp, int ws, int hs) {
    wSz = ws;
    hSz = hs;
    int wToH = wSz - hSz;
    ratio = (float)wSz / (float)wToH;
    xPos = xp;
    yPos = yp - hSz/2;
    slPos = xPos + wSz/2 - hSz/2;
    newSlPos = slPos;
    slPosMin = xPos;
    slPosMax = xPos + wSz;
  }

  void update() {
    hover = hoverEvent();

    if (mousePressed && hover) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newSlPos = constrain(mouseX - hSz/2, slPosMin, slPosMax);
      //println(slPos);
    }
    if (abs(newSlPos - slPos) > 1) {
      slPos = newSlPos;
      //println("pos:" + slPos + ", norm: " + (slPos - xPos) / (float)wSz);
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean hoverEvent() {
    return (mouseX > xPos && mouseX < xPos + wSz &&
      mouseY > yPos && mouseY < yPos + hSz);
  }

  void draw() {
    noStroke();
    fill(#cccccc);
    rect(xPos, yPos, wSz, hSz);
    if (hover || locked) {
      fill(#000000);
    } else {
      fill(#999999);
    }
    rect(slPos, yPos, hSz, hSz);
  }

  float pos() {
    return (slPos - xPos) / (float)wSz;
  }
}


///////////////////////////////////////////////////////////////////////////////

class HCheckbox {
  int wSz, hSz;
  float xPos, yPos;
  boolean hover;
  boolean state;
  String label;

  HCheckbox (String label_, float xp, float yp, int ws, int hs, boolean state_) {
    label = label_;
    wSz = ws;
    hSz = hs;
    xPos = xp;
    yPos = yp - hSz/2;
    state = state_;
    hover = false;
  }

  void update() {
    hover = hoverEvent();
    //if (mousePressed && hover) {
    //  state = !state;
    //}
  }

  boolean hoverEvent() {
    return (mouseX > xPos && mouseX < xPos + wSz &&
      mouseY > yPos && mouseY < yPos + hSz);
  }

  void draw() {
    stroke(#111111);
    strokeWeight(1);
    //if (hover) {
    //  fill(#992200);
    if (state) {
      fill(#0022ff);
    } else {
      fill(#cccccc);
    }
    // TODO: Fix this, set xPos to the start of the text
    text(label, xPos - 60, yPos + 8);
    rect(xPos, yPos, wSz, hSz);
    noStroke();
  }

  boolean checkClick(int cmouseX, int cmouseY) {
    if (cmouseX > xPos && cmouseX < xPos + wSz &&
      cmouseY > yPos && cmouseY < yPos + hSz) {
      state = !state;
      return true;
    }
    return false;
  }

  boolean getState() {
    return state;
  }
}
