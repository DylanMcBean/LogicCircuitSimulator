class Button{
  ArrayList<Shape> shapes = new ArrayList<Shape>();
  String name;
  PVector position;
  
  Button(String _name, PVector pos){
    this.name = _name;
    this.position = pos;
    
    getShape(_name);
  }
  
  void show() {
    for (Shape shape : shapes) {
      fill(shape.fill); 
      beginShape();
      for (PVector point : shape.points) {
        vertex(this.position.x + point.x, this.position.y + point.y);
      }
      endShape(CLOSE);
      updates[0] += 1;
      updates[3] += 1;
    }
    fill(0);
    textSize(14);
    textAlign(CENTER,CENTER);
    text(this.name,this.position.x+25,this.position.y+60);
    updates[0] += 1;
    updates[3] += 1;
  }
  
  void getShape(String name) {
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
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(0, 40),new PVector(40,40), new PVector(40, 0)}, color(200, 100, 90), false));
      break;
    case "OUTPUT":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 20), new PVector(40, 0), new PVector(40, 40)}, color(255, 100, 90), false));
      break;
    }
  }
}
