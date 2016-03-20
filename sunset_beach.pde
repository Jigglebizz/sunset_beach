int X_AXIS = 1;
int Y_AXIS = 2;
int LEFT = 1;
int RIGHT = 2;

int sun_size = 100;
int rock_definition = 45;
int rock_height = 45;
float horizon = 0.65;
float wave_t, wave_t_reverse;

int sun_x, sun_y;
color skyColor1, skyColor2;
int[] leftRocks, rightRocks;

PGraphics pg;
boolean firstDraw;

void setup() {
  size(700, 700);
  
  sun_x = width / 2;
  sun_y = (int)(height * horizon / 2);
  wave_t = 0;
  wave_t_reverse = 0;
  
  pg = createGraphics(width, height);
  firstDraw = true;
  leftRocks = generateRocks(0.33);
  rightRocks = generateRocks(0.25);
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
  updateSkyColor();
}

void updateSkyColor() {
  float inter = map(sun_y, 0, height * horizon, 0, 1);
  
  color skyColor1Low = color(80, 90, 50);
  color skyColor2Low = color(92, 100, 80);

  color skyColor1High  = color(100, 100, 80);
  color skyColor2High  = color(12, 100, 60);

  skyColor1 = pg.lerpColor(skyColor1Low, skyColor1High, inter);
  skyColor2 = pg.lerpColor(skyColor2Low, skyColor2High, inter);  
}

void draw() {
  pg.beginDraw();
  
  // First time setup
  pg.colorMode(HSB, 100f);
  colorMode(HSB, 100f);
  if (firstDraw) {
    background(0);
    updateSkyColor();
    firstDraw = false;
  }
  
  // Draw the sky
  drawGradient(pg, 
                0, (int)(height * (1f - horizon)),
                width, height * (horizon - (1f - horizon)), 
                skyColor1, skyColor2, 
                Y_AXIS);
  
  // Draw the sun
  pg.noStroke();
  pg.fill(15,36,100);
  pg.ellipse(sun_x, sun_y, sun_size, sun_size);
  
  drawRocks(leftRocks, LEFT);
  drawRocks(rightRocks, RIGHT);
  pg.endDraw();
  
  // Cut off all the excess junk if the sun goes below the horizon
  pg.loadPixels();
  for (int x = 0; x < width; x++) {
   for (int y = (int)(height * horizon) + 1; y < height; y++) {
    pg.pixels[x + y*width] =  color(0, 0, 0, 0);
   }
  }
  pg.updatePixels();
  
  // We're gonna make a mask to make waves
  PGraphics mask = createMask();
  
  image(pg, 0, 0);
  pushMatrix();
  translate(0, height);
  
  scale(1, 1 / horizon);
  scale(1, -(1f - horizon));
  image(pg, 0, 0);
  
  // Make waves
  pg.mask(mask);
  
  scale(1, 1.05);
  image(pg, 0, 0);
  popMatrix();
  //image(mask, 0, 0);
}

void drawRocks(int[] rocks, int lr) {
  pg.fill(0);
  pg.beginShape();
  for (int i = 0; i < rocks.length; i+=2) {
    if (lr == LEFT) {
      pg.vertex(rocks[i], rocks[i+1]);
    } else {
      pg.vertex(width - rocks[i], rocks[i+1]);
    }
  }
  pg.endShape();
}

// Returns a list of xy coordinates
int[] generateRocks(float pct_width) {
  int[] rocks = new int[rock_definition * 2 + 2];
  rocks[0] = 0;
  rocks[1] = (int)(height * horizon) + 1;
  
  for (int i = 0; i < rock_definition; i++) {
    rocks[2 + (i * 2)] = i * (int)(((float)width * pct_width) / (float)rock_definition);
    rocks[3 + (i * 2)] = (int)(height * horizon -                                               // Base of rocks
                               rock_height * cos(HALF_PI * ((float)i / (float)rock_definition)) +     // Falloff
                               random(-2, 2));             // Rockiness
    
  }
  
  rocks[rock_definition * 2 + 1] = rocks[1];
  
  return rocks;
}

PGraphics createMask() {
  PGraphics mask = createGraphics(width, height);
  mask.beginDraw();
  mask.background(0);
  mask.colorMode(HSB, 100);
  for (int i = 0; i < width; i++) { 
    mask.stroke(0, 0, 100);
    mask.line(i,
              400 + 10 * sin((0.22 + PI) + (wave_t_reverse * 1 + ((float)i / (float)width))),
              i,
              400 + 8 * sin(PI + 0.3 * (wave_t_reverse + 3 * ((float)i / (float)width))));
    mask.line(i,
              360 + 8 * sin(0.7 * (wave_t + 12 * ((float)i / (float)width))),
              i,
              360 + 5 * sin((wave_t + 8 * ((float)i / (float)width))));
    mask.line(i,
              320 + 10 * sin((0.22 + PI) + (wave_t_reverse * 1 + ((float)i / (float)width))),
              i,
              320 + 8 * sin(PI + 0.3 * (wave_t_reverse + 3 * ((float)i / (float)width))));
    mask.line(i,
              280 + 10 * sin(PI + 0.7 * (wave_t + 2 * ((float)i / (float)width))),
              i,
              280 + 8 * sin((wave_t + 8 * ((float)i / (float)width))));
    mask.line(i,
              230 + 13 * sin(PI * (wave_t_reverse * 1 + ((float)i / (float)width))),
              i,
              230 + 10 * sin((wave_t_reverse + 3 * ((float)i / (float)width))));
    mask.line(i,
              190 + 15 * sin(PI + 0.7 * (wave_t + 5 * ((float)i / (float)width))),
              i,
              195 + 10 * sin((wave_t + 8 * ((float)i / (float)width))));
    mask.line(i,
              150 + 15 * sin(PI + 0.7 * (wave_t_reverse + 2 * ((float)i / (float)width))),
              i,
              145 + 10 * sin((wave_t_reverse + 3 * ((float)i / (float)width))));
    mask.line(i,
              110 + 15 * sin(PI - 0.7 * (wave_t + 2 * ((float)i / (float)width))),
              i,
              110 + 10 * sin(PI - (wave_t + 3 * ((float)i / (float)width))));
    mask.line(i, 
              60 + 25 * sin(wave_t_reverse + ((float)i / (float)width)),
              i,
              50 + 25 * sin(0.8 * (wave_t_reverse + 1 + ((float)i / (float)width))));
    mask.line(i, 
              25 * sin(wave_t + ((float)i / (float)width)),
              i,
              15 + 25 * sin(wave_t + 0.4 + ((float)i / (float)width)));
  }
  wave_t += 0.05;
  wave_t_reverse -= 0.05;
  mask.endDraw();
  return mask;
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