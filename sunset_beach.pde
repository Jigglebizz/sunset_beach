int X_AXIS = 1;
int Y_AXIS = 2;

int sun_x, sun_y;
int sun_size = 100;
float horizon = 0.65;

PGraphics pg;
boolean firstDraw;

void setup() {
  size(1000, 1000);
  
  sun_x = width / 2;
  sun_y = (int)(height * horizon / 2);
  
  pg = createGraphics(width, height);
  firstDraw = true;
}

void mousePressed() {
  updateMouse();
}

void mouseDragged() {
  updateMouse();
}

void updateMouse() {
  sun_x = mouseX;
  sun_y = mouseY;
}

void draw() {
  pg.beginDraw();
  // First time setup
  pg.colorMode(HSB, 100f);
  colorMode(HSB, 100f);
  if (firstDraw) {
   pg.background(0);
   firstDraw = false;
  }
  
  color color1 = color(92, 100, 80);
  color color2 = color(80, 90, 50);
  
  drawGradient(pg, 0, 0, width, height * horizon, color1, color2, Y_AXIS);
  
  pg.noStroke();
  pg.fill(15,36,100);
  pg.ellipse(sun_x, sun_y, sun_size, sun_size);
  
  pg.endDraw();
  image(pg, 0, 0);
}

void drawGradient(PGraphics pg, int x, int y, float w, float h, color c1, color c2, int axis) {
  pg.noFill();
  if (axis == Y_AXIS) {
     for (int i = 0; i < y+h; i++) {
        float inter = map(i, y, y+h, 0, 1);
        color c = pg.lerpColor(c1, c2, inter);
        pg.stroke(c);
        pg.line(x, i, x+w, i);
     }
  }
  else if (axis == X_AXIS) {
     for (int i = 0; i < x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = pg.lerpColor(c1, c2, inter);
      pg.stroke(c);
      pg.line(i, y, i, y+h);
     }
  }
}