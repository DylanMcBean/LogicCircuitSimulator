class CustomGate extends Gate{
  ArrayList<Gate> localGates = new ArrayList<Gate>();
  Boolean locked = false;
  PVector blueprintSize;
  Boolean minimized = false;
  ArrayList<Shape> holderShapes = new ArrayList<Shape>();
  String name = "enter name";
  
  CustomGate(Shape _outline, PVector _position, PVector size){
    super("custom",null,_position);
    this.shapes.add(_outline);
    this.position = _position;
    this.blueprintSize = size;
  }
  
  void show(){
    stroke(255);
    strokeWeight(1*globalScale);
    fill(this.shapes.get(0).fill);
    beginShape();
    for (PVector point : shapes.get(0).points) {
      vertex(this.position.x*globalScale + point.x*globalScale, this.position.y*globalScale + point.y*globalScale);
    }
    endShape(CLOSE);
    textSize(14*globalScale);
    fill(255);
    textAlign(LEFT);
    text(this.name,this.position.x*globalScale,this.position.y*globalScale);
  }
  
  void setupGate(){
    for(Gate g : localGates){
      if(g.type == "INPUT"){
        g.type = "INPUTbp";
        g.shapes = new ArrayList<Shape>();
        g.shapes.add(new Shape(new PVector[]{new PVector(0, 8), new PVector(0, 12),new PVector(20,12), new PVector(20, 8)}, color(231,102,140), false));
        g.inputs.add(new PVector(0, 10));
        g.position = new PVector(this.position.x,g.position.y);
        g.connections_in = new Connection[1];
        g.size = new PVector(20,20);
      } else if(g.type == "OUTPUT"){
        g.type = "OUTPUTbp";
        g.position = new PVector(this.position.x + (blueprintSize.x)/globalScale - 20,g.position.y);
        g.shapes = new ArrayList<Shape>();
        g.shapes.add(new Shape(new PVector[]{new PVector(0, 8), new PVector(0, 12),new PVector(20,12), new PVector(20, 8)}, color(231,102,140), false));
        g.outputs.add(new PVector(20, 10));
        g.size = new PVector(20,20);
      } else if(g.inputsNullCheck() && g.connections_out.size() != 0){
        g.position = new PVector(this.position.x-g.inputs.get(0).x,g.position.y);
      } else if(g.connections_out.size() == 0 && !g.inputsNullCheck()){
        g.position = new PVector(this.position.x + (blueprintSize.x)/globalScale - g.outputs.get(0).x,g.position.y);
      }
    }
  }
  
  void minimize(){
   this.minimized = !this.minimized;
   for(Gate g : localGates){
     g.hidden = this.minimized;
   }
   if(this.minimized){
     this.holderShapes = this.shapes;
     this.shapes = new ArrayList<Shape>();
     this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(0, 50),new PVector(50,50), new PVector(50, 0)}, color(0,90,120,100), false));
     for(Gate g : localGates){
       if (g.type == "INPUTbp" || g.type == "OUTPUTbp"){
         g.position.x = map(g.position.x,this.position.x,this.position.x + blueprintSize.x-20,this.position.x,this.position.x+30);
         g.position.y = map(g.position.y,this.position.y,this.position.y+this.blueprintSize.y-12,this.position.y,this.position.y+38);
       }
     }
   } else if(!this.minimized){
     this.shapes = holderShapes;
     for(Gate g : localGates){
       if (g.type == "INPUTbp" || g.type == "OUTPUTbp"){
         g.position.x = map(g.position.x,this.position.x,this.position.x+30,this.position.x,this.position.x + blueprintSize.x-20);
         g.position.y = map(g.position.y,this.position.y,this.position.y+38,this.position.y,this.position.y+this.blueprintSize.y-12);
       }
     }
   }
  }
  
  void delete(Boolean full){
    if(full){
     for(Gate g: localGates){
       gates.remove(g);
     }
    }
    
    for(Gate g : localGates){
      if(g.type == "INPUTbp"){
        g.type = "INPUT";
        g.shapes = new ArrayList<Shape>();
        g.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(0, 20),new PVector(20,20), new PVector(20, 0)}, color(231,102,140), false));
        g.inputs = new ArrayList<PVector>();
        g.position = new PVector(this.position.x,g.position.y);
        g.connections_in = new Connection[1];
      } else if(g.type == "OUTPUTbp"){
        g.type = "OUTPUT";
        g.position = new PVector(this.position.x + (blueprintSize.x)/globalScale,g.position.y);
        g.shapes = new ArrayList<Shape>();
        g.shapes.add(new Shape(new PVector[]{new PVector(0, 10), new PVector(20, 0), new PVector(20, 20)}, color(231,102,140), false));
        g.outputs = new ArrayList<PVector>();
      }
    }
    customGates.remove(this);
  }
  
  void checkGates(){
    for(int i = localGates.size()-1; i >= 0; i --){
      if(!(localGates.get(i).position.x >= this.position.x-localGates.get(i).inputs.get(0).x && localGates.get(i).position.x <= this.position.x + blueprintSize.x && localGates.get(i).position.y >= this.position.y && localGates.get(i).position.y <= this.position.y + blueprintSize.y)){
        localGates.remove(localGates.get(i));
      }
    }
  }
}
