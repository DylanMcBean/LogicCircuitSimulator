class Gate {
  ArrayList<Shape> shapes = new ArrayList<Shape>();
  String type;
  PVector position, size;
  ArrayList<PVector> inputs = new ArrayList<PVector>();
  ArrayList<PVector> outputs = new ArrayList<PVector>();
  Connection[] connections_in;
  ArrayList<Gate> connections_out = new ArrayList<Gate>();
  String[] connections_out_identifier = null;
  Boolean powered = false, hidden = false;
  int poweredFramesMax = 0, poweredFramesLeft = 0, poweredFrame = -1, blueprint_index=-1;
  Boolean shouldCalculatePowered = false, blueprint_input = false, blueprint_output = false;
  PImage texture_off;
  ArrayList<PImage> texture_on = new ArrayList<PImage>();

  Gate(String name,PVector pos) {
    this.type = name;
    this.position = pos;
    getShape(name);
    connections_in = new Connection[inputs.size()];
  }


  void show(int layer){
    //Show connecting lines
    for (int i = 0; i < connections_in.length; i++) {
      if ((this.hidden == false || this.type=="INPUTbp" || this.blueprint_input == true) && connections_in[i] != null && (this.position.x > -100 && this.position.x < (width+20)/globalScale && this.position.y > -100 && this.position.y < (height+20)/globalScale || connections_in[i].connector.position.x > -100 && connections_in[i].connector.position.x < (width+20)/globalScale && connections_in[i].connector.position.y > -100 && connections_in[i].connector.position.y < (height+20)/globalScale)) {
        if (connections_in[i].connector.powered && layer == 0) {
          stroke(3, 218, 100);
        } else if(layer == 0){
          stroke(211, 47, 47);
        }
        strokeWeight(2*globalScale);
        if(connections_in[i].connector.outputs.size() == 0) {
          connections_in[i] = null;
        } else {
          line(PVector.mult(PVector.add(connections_in[i].connector.position, connections_in[i].connector.outputs.get(connections_in[i].inputIndex)), globalScale), PVector.mult(PVector.add(this.position, new PVector(this.inputs.get(i).x, this.inputs.get(i).y)), globalScale), globalLines, false);
        }
        updates[0] += 1;
        updates[3] += 1;
      }
    }

    if (this.position.x > -100 && this.position.x < (width+20)/globalScale && this.position.y > -100 && this.position.y < (height+20)/globalScale) {
      for (Shape shape : shapes) {
        noStroke();
        if(!this.hidden){
          fill(0,0);
          beginShape();
          for (PVector point : shape.points) {
            vertex(this.position.x*globalScale + point.x*globalScale, this.position.y*globalScale + point.y*globalScale);
          }
          endShape(CLOSE);
          
          image((this.powered && this.texture_on.size() == 1) ? this.texture_on.get(0) : this.texture_off,(this.position.x+this.shapes.get(0).points[0].x)*globalScale,(this.position.y+this.shapes.get(0).points[0].y)*globalScale,this.size.x*globalScale,this.size.y*globalScale);
          if(this.type == "OUTPUT_HEX_DISPLAY"){
            for(int i = 0; i < connections_in.length; i++){
              if(connections_in[i] != null && connections_in[i].connector.powered) image(this.texture_on.get(i),this.position.x*globalScale,this.position.y*globalScale,this.size.x*globalScale,this.size.y*globalScale);
            }
          }
          updates[0] += 1;
          updates[3] += 1;
        }
      }


      strokeWeight(1*globalScale);
      //Show inputs and output connectors
      fill(255);
      for (int i = 0; i < inputs.size(); i ++) {
        if(!hidden || this.type == "INPUTbp" || this.blueprint_input == true) {
          fill(200, 200, 80);
          if (connections_in[i] == null) {
            fill(255, 255, 10);
            ellipse((this.position.x+inputs.get(i).x)*globalScale, (this.position.y+inputs.get(i).y)*globalScale, 6*globalScale, 6*globalScale);
          } else {
            fill(200, 200, 80);
            ellipse((this.position.x+inputs.get(i).x)*globalScale, (this.position.y+inputs.get(i).y)*globalScale, 3*globalScale, 3*globalScale);
          }
          updates[0] += 1;
          updates[3] += 1;
        }
      }

      for (PVector output : outputs) {
        if(!hidden || this.type == "OUTPUTbp" || blueprint_output == true) {
          fill(120, 200, 180);
          ellipse((this.position.x+output.x)*globalScale, (this.position.y+output.y)*globalScale, 5*globalScale, 5*globalScale);
          updates[0] += 1;
          updates[3] += 1;
        }
      }
    }
    //Draw any text
    if (type == "INPUT") {
      textSize(12*globalScale);
      textAlign(CENTER,CENTER);
      fill(0);
      text(powered ? "1" : "0",(this.position.x+10)*globalScale,(this.position.y+10)*globalScale);
    } else if (type == "INPUT_CLOCK"){
      textSize(13*globalScale);
      textAlign(CENTER,CENTER);
      fill(0);
      text(this.poweredFramesMax,(this.position.x+20)*globalScale,(this.position.y+20)*globalScale);
    }
  }
  
  void update(){
    if(this.type == "INPUT_CLOCK"){
      this.powered = (millis()%(this.poweredFramesMax*100) < (this.poweredFramesMax*100)/2);
      this.shouldCalculatePowered = true;
    }
    if(this.shouldCalculatePowered){
     this.calculatePowered(); 
    }
    powerDown();
  }
  
  boolean inputsNullCheck(){
    for(Connection c : this.connections_in){
      if (c != null) return false;
    }
    return true;
  }
  
  void powerDown(){
    if(this.poweredFramesMax > 0) {
      if(this.poweredFramesLeft > 0) this.poweredFramesLeft --;
      if(this.poweredFramesLeft == 0 && this.powered && this.type != "INPUT_CLOCK"){
        this.powered = false;
        this.shouldCalculatePowered = true;
      } 
    }
  }

  void getShape(String name) {
    switch(name) {
    case "AND":
      this.texture_off = and_gate_image;
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(40, 0), new PVector(40, 40), new PVector(0, 40)}));
      inputs.add(new PVector(0, 10));
      inputs.add(new PVector(0, 30));
      outputs.add(new PVector(40, 20));
      this.size = new PVector(40,40);
      break;
    case "NAND":
      this.texture_off = nand_gate_image;
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(40, 0), new PVector(40, 40), new PVector(0, 40)}));
      inputs.add(new PVector(0, 10));
      inputs.add(new PVector(0, 30));
      outputs.add(new PVector(42, 20));
      this.size = new PVector(40,40);
      break;
    case "NOT":
      this.texture_off = not_gate_image;
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(40, 0), new PVector(40, 40), new PVector(0, 40)}));
      inputs.add(new PVector(0, 20));
      outputs.add(new PVector(42, 20));
      this.size = new PVector(40,40);
      break;
    case "OR":
      this.texture_off = or_gate_image;
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(40, 0), new PVector(40, 40), new PVector(0, 40)}));
      inputs.add(new PVector(5, 10));
      inputs.add(new PVector(5, 30));
      outputs.add(new PVector(40, 20));
      this.size = new PVector(40,40);
      break;
    case "NOR":
      this.texture_off = nor_gate_image;
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(40, 0), new PVector(40, 40), new PVector(0, 40)}));
      inputs.add(new PVector(5, 10));
      inputs.add(new PVector(5, 30));
      outputs.add(new PVector(42, 20));
      this.size = new PVector(40,40);
      break;
    case "XOR":
      this.texture_off = xor_gate_image;
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(40, 0), new PVector(40, 40), new PVector(0, 40)}));
      inputs.add(new PVector(1, 10));
      inputs.add(new PVector(1, 30));
      outputs.add(new PVector(42, 20));
      this.size = new PVector(40,40);
      break;
    case "XNOR":
      this.texture_off = xnor_gate_image;
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(40, 0), new PVector(40, 40), new PVector(0, 40)}));
      inputs.add(new PVector(1, 10));
      inputs.add(new PVector(1, 30));
      outputs.add(new PVector(42, 20));
      this.size = new PVector(40,40);
      break;
    case "CONNECTOR":
      this.texture_off = connector_image;
      this.shapes.add(new Shape(new PVector[]{new PVector(-5, -5), new PVector(5, 0), new PVector(5, 5), new PVector(0, 5)}));
      inputs.add(new PVector(0, 0));
      outputs.add(new PVector(0, 0));
      this.size = new PVector(10,10);
      break;
    case "INPUT":
      this.texture_off = input_image;
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 0), new PVector(20, 20), new PVector(0, 20)}));
      outputs.add(new PVector(20, 10));
      this.size = new PVector(20,20);
      this.texture_on.add(input_image_true);
      break;
    case "INPUTbp":
      this.texture_off = input_image;
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 0), new PVector(20, 20), new PVector(0, 20)}));
      outputs.add(new PVector(20, 10));
      inputs.add(new PVector(0, 10));
      this.size = new PVector(20,20);
      this.texture_on.add(input_image_true);
      break;
    case "INPUT_BUTTON":
      this.texture_off = input_button_image;
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 0), new PVector(20, 20), new PVector(0, 20)}));
      outputs.add(new PVector(20, 10));
      poweredFramesMax = 60;
      this.size = new PVector(20,20);
      break;
    case "INPUT_CLOCK":
      this.texture_off = input_clock_image;
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(40, 0), new PVector(40, 40), new PVector(0, 40)}));
      outputs.add(new PVector(40, 20));
      poweredFramesMax = 1;
      this.size = new PVector(40,40);
      break;
    case "OUTPUT":
      this.texture_off = output_image;
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 0), new PVector(20, 20), new PVector(0, 20)}));
      inputs.add(new PVector(0, 10));
      this.size = new PVector(20,20);
      this.texture_on.add(output_image_true);
      break;
    case "OUTPUTbp":
      this.texture_off = output_image;
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(20, 0), new PVector(20, 20), new PVector(0, 20)}));
      inputs.add(new PVector(0, 10));
      outputs.add(new PVector(20, 10));
      this.size = new PVector(20,20);
      this.texture_on.add(output_image_true);
      break;
    case "OUTPUT_HEX_DISPLAY":
      this.texture_off = seven_seg_display_image;
      this.shapes.add(new Shape(new PVector[]{new PVector(0, 0), new PVector(40, 0), new PVector(40, 80), new PVector(0, 80)}));
      inputs.add(new PVector(0, 10));
      inputs.add(new PVector(0, 18.571));
      inputs.add(new PVector(0, 27.143));
      inputs.add(new PVector(0, 35.714));
      inputs.add(new PVector(0, 44.286));
      inputs.add(new PVector(0, 52.857));
      inputs.add(new PVector(0, 61.428));
      inputs.add(new PVector(0, 70));
      this.size = new PVector(40,80);
      this.texture_on.add(seven_seg_display_image_a);
      this.texture_on.add(seven_seg_display_image_b);
      this.texture_on.add(seven_seg_display_image_c);
      this.texture_on.add(seven_seg_display_image_d);
      this.texture_on.add(seven_seg_display_image_e);
      this.texture_on.add(seven_seg_display_image_f);
      this.texture_on.add(seven_seg_display_image_g);
      this.texture_on.add(seven_seg_display_image_dp);
      break;
    }
  }

  void calculatePowered() {
    if(this.shouldCalculatePowered = false) return;
    switch(this.type) {
    case "AND":
      if (connections_in[0] != null && connections_in[1] != null && connections_in[0].connector.powered && connections_in[1].connector.powered) this.powered = true;
      else powered = false;
      break;
    case "NOT":
      if (connections_in[0] != null && connections_in[0].connector.powered) this.powered = false;
      else powered = true;
      break;
    case "NAND":
      if (connections_in[0] != null && connections_in[1] != null && connections_in[0].connector.powered && connections_in[1].connector.powered) this.powered = false;
      else powered = true;
      break;
    case "OR":
      if (connections_in[0] != null && connections_in[1] != null) {
        if (connections_in[0].connector.powered || connections_in[1].connector.powered) this.powered = true;
        else powered = false;
      }
      break;
    case "NOR":
      if (connections_in[0] != null && connections_in[1] != null) {
        if (connections_in[0].connector.powered || connections_in[1].connector.powered) this.powered = false;
        else powered = true;
      }
      break;
    case "XOR":
      if (connections_in[0] != null && connections_in[1] != null) {
        if ((connections_in[0].connector.powered || connections_in[1].connector.powered) && !(connections_in[0].connector.powered && connections_in[1].connector.powered)) this.powered = true;
        else powered = false;
      }
      break;
    case "XNOR":
      if (connections_in[0] != null && connections_in[1] != null) {
        if ((connections_in[0].connector.powered || connections_in[1].connector.powered) && !(connections_in[0].connector.powered && connections_in[1].connector.powered)) this.powered = false;
        else powered = true;
      }
      break;
    case "CONNECTOR":
        if (connections_in[0] != null && connections_in[0].connector.powered) this.powered = true;
        else this.powered = false;
      break;
    case "OUTPUT":
      if (connections_in[0] != null && connections_in[0].connector.powered) this.powered = true;
      else this.powered = false;
      break;
    case "OUTPUT_HEX_DISPLAY":
      this.powered = false;
      for(int i = 0; i < connections_in.length; i ++) {
        if (connections_in[i] != null && connections_in[i].connector.powered) this.powered = true;
      }
      break;
    case "INPUTbp":
      if (connections_in[0] != null && connections_in[0].connector.powered) this.powered = true;
      else this.powered = false;
      break;
    case "OUTPUTbp":
      if (connections_in[0] != null && connections_in[0].connector.powered) this.powered = true;
      else this.powered = false;
      break;
    }
    
      for (Gate g : connections_out) {
        if(g.type == "CONNECTOR"){
          g.shouldCalculatePowered = true;
          g.calculatePowered();
          g.poweredFrame = -1;
        } else if (g.type != "CONNECTOR"){
          g.shouldCalculatePowered = true; //<>//
          toBeUpdated.add(g);
          shouldDraw = true;
        }
      }
      
      //toBeUpdated.remove(this);
      
      updates[2] += 1;
      updates[3] += 1;
  }

  void updateConnections() {
    for (int i = 0; i < this.connections_in.length; i ++) {
      if (this.connections_in[i] != null) {
        Boolean found = false;
        for (Gate g : gates) {
          if (g == this.connections_in[i].connector) {
            found = true;
            break;
          }
        }
        if (found == false) this.connections_in[i] = null;
      }
    }
  }
}
