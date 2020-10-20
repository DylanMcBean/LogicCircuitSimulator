class Button {
  ArrayList<Shape> shapes = new ArrayList<Shape>();
  String name, title;
  PVector position, size;
  PImage texture;
  int anim_counter = 0;
  ToolTip tool_tip;

  Button(String _name, String _title, String[] ttt, PImage texture, PVector pos, PVector size) {
    this.name = _name;
    this.title = _title;
    this.position = pos;
    this.size = size;
    this.texture = texture;
    this.tool_tip = new ToolTip(ttt);
    this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(40, 0), new PVector(40, 40), new PVector(0, 40)}));
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
    
    if(mouseX > this.position.x && mouseX < this.position.x+this.size.x && mouseY > this.position.y && mouseY < this.position.y + this.size.y){
      this.anim_counter--;
      if(this.anim_counter < 0)this.tool_tip.show();
    } else {
     this.anim_counter = 40; 
    }
  }
}
