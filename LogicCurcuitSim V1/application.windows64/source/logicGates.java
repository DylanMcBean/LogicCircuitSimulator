import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class logicGates extends PApplet {

ArrayList<Gate> gates = new ArrayList<Gate>(); //<>//
ArrayList<Button> buttons = new ArrayList<Button>();
Gate editing;
int outputIndex = -1;
PImage bin;
float globalScale = 1;
PVector globalOffset;

public void setup() {
  
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


public boolean pixelInPoly(PVector[] verts, PVector pos) {
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

public void line(PVector point1, PVector point2, String type, Boolean os) {
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


public void draw() {
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

public void mousePressed() {
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

public void mouseReleased() {
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

public void mouseDragged() {
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

public void mouseClicked() {
  for (Gate s : gates) {
    if (pixelInPoly(s.shapes.get(0).points, PVector.sub(new PVector(mouseX, mouseY), PVector.mult(s.position, globalScale))) && s.type == "INPUT") {
      s.powered = !s.powered;
    }
  }
}

public void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e == -1 && globalScale < 5) globalScale += 0.1f;
  if (e == 1 && globalScale > 0.5f) globalScale -= 0.1f;
}

public void keyPressed() {
  if (key == 'w') {
    gates.add(new Gate("OUTPUT", PVector.div(new PVector(mouseX, mouseY), globalScale)));
  }
}

public void drawBackground(){
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
class Button{
  ArrayList<Shape> shapes = new ArrayList<Shape>();
  String name;
  PVector position;
  
  Button(String _name, PVector pos){
    this.name = _name;
    this.position = pos;
    
    getShape(_name);
  }
  
  public void show() {
    for (Shape shape : shapes) {
      fill(shape.fill); 
      beginShape();
      for (PVector point : shape.points) {
        vertex(this.position.x + point.x, this.position.y + point.y);
      }
      endShape(CLOSE);
    }
    fill(0);
    textSize(14);
    textAlign(CENTER,CENTER);
    text(this.name,this.position.x+25,this.position.y+60);
  }
  
  public void getShape(String name) {
    this.shapes.add(new Shape(new PVector[]{new PVector(-10, -10),new PVector(60, -10),new PVector(60, 70),new PVector(-10, 70)},color(127,127,200,100),false));
    switch(name) {
    case "AND":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 0), new PVector(30, 5), new PVector(40, 20), new PVector(30, 35), new PVector(20, 40), new PVector(0, 40)}, color(50, 120, 200), false));
      break;
    case "NAND":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 0), new PVector(30, 5), new PVector(40, 20), new PVector(30, 35), new PVector(20, 40), new PVector(0, 40)}, color(50, 120, 200), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(40, 20), new PVector(45, 15), new PVector(50, 20), new PVector(45, 25)}, color(50, 120, 200), false));
      break;
    case "NOT":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(40, 20), new PVector(0, 40)}, color(50, 120, 200), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(40, 20), new PVector(45, 15), new PVector(50, 20), new PVector(45, 25)}, color(50, 120, 200), false));
      break;
    case "OR":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 5), new PVector(30, 10), new PVector(40, 20), new PVector(30, 30), new PVector(20, 35), new PVector(0, 40), new PVector(5, 30), new PVector(5, 10)}, color(50, 120, 200), false));
      break;
    case "NOR":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 5), new PVector(30, 10), new PVector(40, 20), new PVector(30, 30), new PVector(20, 35), new PVector(0, 40), new PVector(5, 30), new PVector(5, 10)}, color(50, 120, 200), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(40, 20), new PVector(45, 15), new PVector(50, 20), new PVector(45, 25)}, color(50, 120, 200), false));
      break;
    case "XOR":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 5), new PVector(30, 10), new PVector(40, 20), new PVector(30, 30), new PVector(20, 35), new PVector(0, 40), new PVector(5, 30), new PVector(5, 10)}, color(50, 120, 200), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(-5, 0), new PVector(0, 10), new PVector(0, 30), new PVector(-5, 40), new PVector(-2, 30), new PVector(-2, 10)}, color(50, 120, 200), false));
      break;
    case "XNOR":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 5), new PVector(30, 10), new PVector(40, 20), new PVector(30, 30), new PVector(20, 35), new PVector(0, 40), new PVector(5, 30), new PVector(5, 10)}, color(50, 120, 200), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(-5, 0), new PVector(0, 10), new PVector(0, 30), new PVector(-5, 40), new PVector(-2, 30), new PVector(-2, 10)}, color(50, 120, 200), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(40, 20), new PVector(45, 15), new PVector(50, 20), new PVector(45, 25)}, color(50, 120, 200), false));
      break;
    case "INPUT":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(40, 20), new PVector(0, 40)}, color(200, 100, 90), false));
      break;
    case "OUTPUT":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 20), new PVector(40, 0), new PVector(40, 40)}, color(255, 100, 90), false));
      break;
    }
  }
}
class Gate {
  ArrayList<Shape> shapes = new ArrayList<Shape>();
  int fillColor;
  boolean outline;
  String type;
  PVector position;
  ArrayList<PVector> inputs = new ArrayList<PVector>();
  ArrayList<PVector> outputs = new ArrayList<PVector>();
  Connection[] connections;
  Boolean powered = false;

  Gate(String name, PVector pos) {
    this.type = name;
    this.position = pos;
    getShape(name);
    connections = new Connection[inputs.size()];
  }


  public void show() {
    for (Shape shape : shapes) {
      if (outline) stroke(0);
      else noStroke();

      if (type == "INPUT" && powered) {
        stroke(0, 200, 100);
        strokeWeight(3*globalScale);
      }
      
      if (type == "OUTPUT" && powered) {
        stroke(0, 150, 80);
        strokeWeight(3*globalScale);
        fill(0,200,100);
      } else {
       fill(shape.fill); 
      }

      
      beginShape();
      for (PVector point : shape.points) {
        vertex(this.position.x*globalScale + point.x*globalScale, this.position.y*globalScale + point.y*globalScale);
      }
      endShape(CLOSE);
    }

    //Show connecting lines
    for (int i = 0; i < connections.length; i++) {
      if (connections[i] != null) {
        if (connections[i].connector.powered) {
          stroke(0, 200, 100);
        } else {
          stroke(255, 20, 50);
        }
        strokeWeight(2*globalScale);
        line(PVector.mult(PVector.add(connections[i].connector.position, connections[i].connector.outputs.get(connections[i].inputIndex)),globalScale), PVector.mult(PVector.add(this.position, new PVector(this.inputs.get(i).x, this.inputs.get(i).y)),globalScale), "spline", false);
      }
    }
    

    if (outline) stroke(0);
    else noStroke();
    strokeWeight(1*globalScale);
    //Show inputs and output connectors
    fill(255);
    for (int i = 0; i < inputs.size(); i ++) {
      fill(200, 200, 80);
      if (connections[i] == null) {
        fill(255, 255, 10);
        ellipse((this.position.x+inputs.get(i).x)*globalScale, (this.position.y+inputs.get(i).y)*globalScale, 6*globalScale, 6*globalScale);
      } else {
        fill(200, 200, 80);
        ellipse((this.position.x+inputs.get(i).x)*globalScale, (this.position.y+inputs.get(i).y)*globalScale, 3*globalScale, 3*globalScale);
      }
    }

    for (PVector output : outputs) {
      fill(120, 200, 180);
      ellipse((this.position.x+output.x)*globalScale, (this.position.y+output.y)*globalScale, 5*globalScale, 5*globalScale);
    }
  }

  public void getShape(String name) {
    switch(name) {
    case "AND":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 0), new PVector(30, 5), new PVector(40, 20), new PVector(30, 35), new PVector(20, 40), new PVector(0, 40)}, color(50, 120, 200), false));
      inputs.add(new PVector(0, 10));
      inputs.add(new PVector(0, 30));
      outputs.add(new PVector(40, 20));
      break;
    case "NAND":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 0), new PVector(30, 5), new PVector(40, 20), new PVector(30, 35), new PVector(20, 40), new PVector(0, 40)}, color(50, 120, 200), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(40, 20), new PVector(45, 15), new PVector(50, 20), new PVector(45, 25)}, color(50, 120, 200), false));
      inputs.add(new PVector(0, 10));
      inputs.add(new PVector(0, 30));
      outputs.add(new PVector(50, 20));
      break;
    case "NOT":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(40, 20), new PVector(0, 40)}, color(50, 120, 200), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(40, 20), new PVector(45, 15), new PVector(50, 20), new PVector(45, 25)}, color(50, 120, 200), false));
      inputs.add(new PVector(0, 20));
      outputs.add(new PVector(50, 20));
      break;
    case "OR":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 5), new PVector(30, 10), new PVector(40, 20), new PVector(30, 30), new PVector(20, 35), new PVector(0, 40), new PVector(5, 30), new PVector(5, 10)}, color(50, 120, 200), false));
      inputs.add(new PVector(5, 10));
      inputs.add(new PVector(5, 30));
      outputs.add(new PVector(40, 20));
      break;
    case "NOR":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 5), new PVector(30, 10), new PVector(40, 20), new PVector(30, 30), new PVector(20, 35), new PVector(0, 40), new PVector(5, 30), new PVector(5, 10)}, color(50, 120, 200), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(40, 20), new PVector(45, 15), new PVector(50, 20), new PVector(45, 25)}, color(50, 120, 200), false));
      inputs.add(new PVector(5, 10));
      inputs.add(new PVector(5, 30));
      outputs.add(new PVector(50, 20));
      break;
    case "XOR":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 5), new PVector(30, 10), new PVector(40, 20), new PVector(30, 30), new PVector(20, 35), new PVector(0, 40), new PVector(5, 30), new PVector(5, 10)}, color(50, 120, 200), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(-5, 0), new PVector(0, 10), new PVector(0, 30), new PVector(-5, 40), new PVector(-2, 30), new PVector(-2, 10)}, color(50, 120, 200), false));
      inputs.add(new PVector(-5, 10));
      inputs.add(new PVector(-5, 30));
      outputs.add(new PVector(40, 20));
      break;
    case "XNOR":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 5), new PVector(30, 10), new PVector(40, 20), new PVector(30, 30), new PVector(20, 35), new PVector(0, 40), new PVector(5, 30), new PVector(5, 10)}, color(50, 120, 200), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(-5, 0), new PVector(0, 10), new PVector(0, 30), new PVector(-5, 40), new PVector(-2, 30), new PVector(-2, 10)}, color(50, 120, 200), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(40, 20), new PVector(45, 15), new PVector(50, 20), new PVector(45, 25)}, color(50, 120, 200), false));
      inputs.add(new PVector(-5, 10));
      inputs.add(new PVector(-5, 30));
      outputs.add(new PVector(50, 20));
      break;
    case "INPUT":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 10), new PVector(0, 20)}, color(200, 100, 90), false));
      outputs.add(new PVector(20, 10));
      break;
    case "OUTPUT":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 10), new PVector(20, 0), new PVector(20, 20)}, color(255, 100, 90), false));
      inputs.add(new PVector(0, 10));
      break;
    }
  }

  public void calculatePowered() {
    switch(this.type) {
    case "AND":
      if (connections[0] != null && connections[1] != null && connections[0].connector.powered && connections[1].connector.powered) this.powered = true;
      else powered = false;
      break;
    case "NOT":
      if (connections[0] != null && connections[0].connector.powered) this.powered = false;
      else powered = true;
      break;
    case "NAND":
      if (connections[0] != null && connections[1] != null && connections[0].connector.powered && connections[1].connector.powered) this.powered = false;
      else powered = true;
      break;
    case "OR":
      if (connections[0] != null && connections[1] != null) {
        if (connections[0].connector.powered || connections[1].connector.powered) this.powered = true;
        else powered = false;
      }
      break;
    case "NOR":
      if (connections[0] != null && connections[1] != null) {
        if (connections[0].connector.powered || connections[1].connector.powered) this.powered = false;
        else powered = true;
      }
      break;
    case "XOR":
      if (connections[0] != null && connections[1] != null) {
        if ((connections[0].connector.powered || connections[1].connector.powered) && !(connections[0].connector.powered && connections[1].connector.powered)) this.powered = true;
        else powered = false;
      }
      break;
    case "XNOR":
      if (connections[0] != null && connections[1] != null) {
        if ((connections[0].connector.powered || connections[1].connector.powered) && !(connections[0].connector.powered && connections[1].connector.powered)) this.powered = false;
        else powered = true;
      }
      break;
    case "OUTPUT":
      if (connections[0] != null && connections[0].connector.powered) this.powered = true;
      else this.powered = false;
    }
  }
  
  public void updateConnections(){
    for(int i = 0; i < this.connections.length; i ++){
      if (this.connections[i] != null) {
        Boolean found = false;
        for (Gate g : gates) {
          if (g == this.connections[i].connector) {
            found = true;
            break;
          }
        }
        if (found == false) this.connections[i] = null;
      }
    }
  }
}
class Shape{
  PVector[] points;
  int fill;
  Boolean outline;
  
  Shape(PVector[] p, int c, Boolean o){
    this.points = p;
    this.fill = c;
    this.outline = o;
  }
}
class Connection{
  Gate connector;
  int inputIndex;
  Connection(Gate s, int inIndex){
    connector = s;
    inputIndex = inIndex;
  }
}
  public void settings() {  size(1400, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "logicGates" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
