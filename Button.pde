class Button {
  ArrayList<Shape> shapes = new ArrayList<Shape>();
  String name, title;
  PVector position, size;
  PImage texture;

  Button(String _name, String _title, String texture, PVector pos, PVector size) {
    this.name = _name;
    this.title = _title;
    this.position = pos;
    this.size = size;
    this.texture = loadImage(texture);
    getShape(_name);
    println(this.shapes);
  }

  void show() {
    for (Shape shape : shapes) {
      noFill();//fill(shape.fill);
      noStroke();
      beginShape();
      for (PVector point : shape.points) {
        vertex(this.position.x + point.x, this.position.y + point.y);
      }
      endShape(CLOSE);
      updates[0] += 1;
      updates[3] += 1;
    }
    image(this.texture, this.position.x, this.position.y, this.size.x, this.size.y);
    fill(0);
    textSize(14);
    textAlign(CENTER, CENTER);
    text(this.title, this.position.x+25, this.position.y+60);
    updates[0] += 1;
    updates[3] += 1;
  }

  void getShape(String name) {
    switch(name) {
    case "AND":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 0), new PVector(30, 5), new PVector(40, 20), new PVector(30, 35), new PVector(20, 40), new PVector(0, 40)}, color(64, 138, 249), false));
      break;
    case "NAND":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 0), new PVector(30, 5), new PVector(40, 20), new PVector(30, 35), new PVector(20, 40), new PVector(0, 40)}, color(64, 138, 249), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(40, 20), new PVector(45, 15), new PVector(50, 20), new PVector(45, 25)}, color(64, 138, 249), false));
      break;
    case "NOT":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(40, 20), new PVector(0, 40)}, color(64, 138, 249), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(40, 20), new PVector(45, 15), new PVector(50, 20), new PVector(45, 25)}, color(64, 138, 249), false));
      break;
    case "OR":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 5), new PVector(30, 10), new PVector(40, 20), new PVector(30, 30), new PVector(20, 35), new PVector(0, 40), new PVector(5, 30), new PVector(5, 10)}, color(64, 138, 249), false));
      break;
    case "NOR":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 5), new PVector(30, 10), new PVector(40, 20), new PVector(30, 30), new PVector(20, 35), new PVector(0, 40), new PVector(5, 30), new PVector(5, 10)}, color(64, 138, 249), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(40, 20), new PVector(45, 15), new PVector(50, 20), new PVector(45, 25)}, color(64, 138, 249), false));
      break;
    case "XOR":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 5), new PVector(30, 10), new PVector(40, 20), new PVector(30, 30), new PVector(20, 35), new PVector(0, 40), new PVector(5, 30), new PVector(5, 10)}, color(64, 138, 249), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(-5, 0), new PVector(0, 10), new PVector(0, 30), new PVector(-5, 40), new PVector(-2, 30), new PVector(-2, 10)}, color(64, 138, 249), false));
      break;
    case "XNOR":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 5), new PVector(30, 10), new PVector(40, 20), new PVector(30, 30), new PVector(20, 35), new PVector(0, 40), new PVector(5, 30), new PVector(5, 10)}, color(64, 138, 249), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(-5, 0), new PVector(0, 10), new PVector(0, 30), new PVector(-5, 40), new PVector(-2, 30), new PVector(-2, 10)}, color(64, 138, 249), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(40, 20), new PVector(45, 15), new PVector(50, 20), new PVector(45, 25)}, color(64, 138, 249), false));
      break;
    case "INPUT":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(0, 40), new PVector(40, 40), new PVector(40, 0)}, color(231, 102, 140), false));
      break;
    case "INPUT_BUTTON":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(0, 40), new PVector(40, 40), new PVector(40, 0)}, color(231, 102, 140), false));
      this.shapes.add(new Shape(new PVector[]{new PVector(26, 34), new PVector(30, 32), new PVector(32, 30), new PVector(34, 16), new PVector(34, 12), new PVector(32, 8), new PVector(30, 6), new PVector(26, 4), new PVector(12, 4), new PVector(8, 6), new PVector(6, 8), new PVector(4, 12), new PVector(4, 26), new PVector(6, 30), new PVector(8, 32), new PVector(12, 34)}, color(231, 231, 102), false));
      break;
    case "INPUT_CLOCK":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(0, 40), new PVector(40, 40), new PVector(40, 0)}, color(231, 102, 140), false));
      break;
    case "OUTPUT":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 20), new PVector(40, 0), new PVector(40, 40)}, color(231, 102, 140), false));
      break;
    case "OUTPUT_HEX_DISPLAY":
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(0, 40), new PVector(40, 40), new PVector(40, 0)}, color(231, 102, 140), false));
      break;
    }
  }
}
