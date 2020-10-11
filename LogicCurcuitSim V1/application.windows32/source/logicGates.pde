ArrayList<Gate> gates = new ArrayList<Gate>(); //<>//
ArrayList<Button> buttons = new ArrayList<Button>();
Gate editing;
int outputIndex = -1;
PImage bin;
float globalScale = 1;
PVector globalOffset;

void setup() {
  size(1400, 800);
  buttons.add(new Button("AND", new PVector(15, buttons.size()*85+15)));
  buttons.add(new Button("NAND", new PVector(15, buttons.size()*85+15)));
  buttons.add(new Button("NOT", new PVector(15, buttons.size()*85+15)));
  buttons.add(new Button("OR", new PVector(15, buttons.size()*85+15)));
  buttons.add(new Button("NOR", new PVector(15, buttons.size()*85+15)));
  buttons.add(new Button("XOR", new PVector(15, buttons.size()*85+15)));
  buttons.add(new Button("XNOR", new PVector(15, buttons.size()*85+15)));
  buttons.add(new Button("INPUT", new PVector(15, buttons.size()*85+15)));
  buttons.add(new Button("OUTPUT", new PVector(15, buttons.size()*85+15)));

  bin = loadImage("Data/recycle-bin.png");
  globalOffset = new PVector(0, 0);
}


boolean pixelInPoly(PVector[] verts, PVector pos) {
  int i, j;
  boolean c=false;
  int sides = verts.length;
  pos = PVector.div(pos, globalScale);
  for (PVector p : verts) {
    p = PVector.mult(p, globalScale);
  }
  for (i=0, j=sides-1; i<sides; j=i++) {
    if (( ((verts[i].y <= pos.y) && (pos.y < verts[j].y)) || ((verts[j].y <= pos.y) && (pos.y < verts[i].y))) &&
      (pos.x < (verts[j].x - verts[i].x) * (pos.y - verts[i].y) / (verts[j].y - verts[i].y) + verts[i].x)) {
      c = !c;
    }
  }
  return c;
}

void line(PVector point1, PVector point2, String type, Boolean os) {
  if (os) {
    strokeWeight(1);
    stroke(255);
  }
  switch(type) { 
  case "stright": 
    line(point1.x, point1.y, point2.x, point2.y);
    break;
  case "stright spline":
    line(point1.x, point1.y, point1.x + (point2.x-point1.x)/3, point1.y);
    line(point1.x + (point2.x-point1.x)/3, point1.y, point2.x - (point2.x-point1.x)/3, point2.y);
    line(point2.x - (point2.x-point1.x)/3, point2.y, point2.x, point2.y);
    break;
  case "spline":
    float medianX = ((point1.x + (point2.x-point1.x)/3)+(point2.x - (point2.x-point1.x)/3))/2;
    float medianY = (point1.y+point2.y)/2;
    noFill();
    bezier(point1.x, point1.y, (point1.x+(point2.x-point1.x)/3), point1.y, ((point1.x+(point2.x-point1.x)/3)+medianX)/2, (point1.y+medianY)/2, medianX, medianY);
    bezier(medianX, medianY, ((point2.x-(point2.x-point1.x)/3)+medianX)/2, (point2.y+medianY)/2, point2.x-(point2.x-point1.x)/3, point2.y, point2.x, point2.y);
  }
}


void draw() {
  background(51);
  //drawBackground();
  for (Gate s : gates) {
    s.show();
    s.calculatePowered();
  }

  stroke(255);
  noFill();

  if (editing != null && outputIndex != -2) line(PVector.mult(PVector.add(editing.position, editing.outputs.get(outputIndex)), globalScale), new PVector(mouseX, mouseY), "spline", true);

  noStroke();
  fill(255);
  rect(0, 0, 80, height);
  if (outputIndex == -2) {
    fill(200, 30, 60, 50);
    rect(80, height-60, width-80, 60);
    image(bin, width/2, height-60, 60, 60);
  }


  for (Button b : buttons) {
    b.show();
  }
  textSize(20);
  text("Zoom: x"+nf(globalScale,0,1),width-70,10);
}

void mousePressed() {
  if (mouseX > 80) {
    for (Gate s : gates) {
      for (int i = 0; i < s.outputs.size(); i++) {
        if (PVector.dist(new PVector(mouseX, mouseY), PVector.mult(PVector.add(s.position, s.outputs.get(i)), globalScale)) < (8*globalScale)) {
          editing = s;
          outputIndex = i;
          break;
        }
      }
      if (pixelInPoly(s.shapes.get(0).points, PVector.sub(new PVector(mouseX, mouseY), PVector.mult(s.position, globalScale)))) {
        editing = s;
        outputIndex = -2;
      }
      if (outputIndex != -1) break;
    }
  } else {
    float holder = globalScale;
    globalScale = 1;
    for ( Button b : buttons) {
      if (pixelInPoly(b.shapes.get(0).points, PVector.sub(new PVector(mouseX, mouseY), b.position))) {
        Gate _new = null;
        globalScale = holder;
        switch(b.name) {
        case "AND": 
          _new = new Gate("AND", PVector.div(new PVector(mouseX, mouseY),globalScale));
          gates.add(_new);
          break;
        case "NAND": 
          _new = new Gate("NAND", PVector.div(new PVector(mouseX, mouseY),globalScale));
          gates.add(_new);
          break;
        case "NOT": 
          _new = new Gate("NOT", PVector.div(new PVector(mouseX, mouseY),globalScale));
          gates.add(_new);
          break;
        case "OR": 
          _new = new Gate("OR", PVector.div(new PVector(mouseX, mouseY),globalScale));
          gates.add(_new);
          break;
        case "NOR": 
          _new = new Gate("NOR", PVector.div(new PVector(mouseX, mouseY),globalScale));
          gates.add(_new);
          break;
        case "XOR": 
          _new = new Gate("XOR", PVector.div(new PVector(mouseX, mouseY),globalScale));
          gates.add(_new);
          break;
        case "XNOR": 
          _new = new Gate("XNOR", PVector.div(new PVector(mouseX, mouseY),globalScale));
          gates.add(_new);
          break;
        case "INPUT": 
          _new = new Gate("INPUT", PVector.div(new PVector(mouseX, mouseY),globalScale));
          gates.add(_new);
          break;
        case "OUTPUT": 
          _new = new Gate("OUTPUT", PVector.div(new PVector(mouseX, mouseY),globalScale));
          gates.add(_new);
          break;
        }
        editing = _new;
        outputIndex = -2;
      }
    }
  }
}

void mouseReleased() {
  if (outputIndex != -2)
    for (Gate s : gates) {
      if(s != editing){
        for (int i = 0; i < s.inputs.size(); i++) {
          if (PVector.dist(new PVector(mouseX, mouseY), PVector.mult(PVector.add(s.position, s.inputs.get(i)), globalScale)) < (12*globalScale)) {
            if (editing != null)
              s.connections[i] = new Connection(editing, outputIndex);
            else s.connections[i] = null;
            editing = null;
            outputIndex = -1;
            break;
          }
        }
        if (outputIndex == -1 && editing != null) break;
      }
    }

  if (outputIndex == -2 && mouseY >= height-80 && mouseX >= 80) {
    gates.remove(editing);
    for (Gate s : gates) {
      s.updateConnections();
    }
  }
  if (outputIndex != -1) {
    editing = null;
    outputIndex = -1;
  }
}

void mouseDragged() {
  if (outputIndex == -2) {
    editing.position = PVector.add(editing.position, PVector.div(new PVector(mouseX - pmouseX, mouseY - pmouseY), globalScale));
  } else if (mouseX > 80 && outputIndex == -1) {
    PVector movedBy = PVector.div(new PVector(mouseX - pmouseX, mouseY - pmouseY), globalScale);
    globalOffset = PVector.add(globalOffset, movedBy);
    for (Gate s : gates) {
      s.position = PVector.add(s.position, movedBy);
    }
  }
}

void mouseClicked() {
  for (Gate s : gates) {
    if (pixelInPoly(s.shapes.get(0).points, PVector.sub(new PVector(mouseX, mouseY), PVector.mult(s.position, globalScale))) && s.type == "INPUT") {
      s.powered = !s.powered;
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e == -1 && globalScale < 5) globalScale += 0.1;
  if (e == 1 && globalScale > 0.5) globalScale -= 0.1;
}

void keyPressed() {
  if (key == 'w') {
    gates.add(new Gate("OUTPUT", PVector.div(new PVector(mouseX, mouseY), globalScale)));
  }
}

void drawBackground(){
  if(globalScale>=1){
    stroke(20,60,200,100);
    strokeWeight(1*globalScale);
    for(int x = -40; x <= width+40; x+=20*globalScale){
      line(x+((globalOffset.x*globalScale)%(20*globalScale)),-20+((globalOffset.y*globalScale)%(20*globalScale)),x+((globalOffset.x*globalScale)%(20*globalScale)),height+20+((globalOffset.y*globalScale)%(20*globalScale)));
    }
    for(int y = -40; y <= height+40; y+=20*globalScale){
      line(-20-((globalOffset.x*globalScale)%(20*globalScale)),y+((globalOffset.y*globalScale)%(20*globalScale)),width+20-((globalOffset.x*globalScale)%(20*globalScale)),y+((globalOffset.y*globalScale)%(20*globalScale)));
    }
  }
}
