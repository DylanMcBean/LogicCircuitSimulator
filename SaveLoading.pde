import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.io.DataOutputStream;
import java.io.DataInputStream;
import java.io.IOException;

File saved_last;

void Save(Boolean auto) {
  if (saved_last != null) saveStrings(dataPath("settings.settings"),new String[]{saved_last.getAbsolutePath()});
  if(!auto){
    File temp = new File("data/saves/save_file.lcs");
    selectOutput("select file to save to:", "binarySave", temp, this, null, null);
  } else if(auto) {
    println("auto save.");
    binarySave(saved_last != null ? saved_last : new File(dataPath("saves/temp.lcs")));
    notifications.add(new Notification("Save", new String[]{"Auto Save",""+saved_last.length()+" bytes."},50,true));
  }
}

void Load() {
  try{
  if(saved_last != null) Save(true);
  File temp = new File("data/saves/save_file.lcs");
  selectInput("select file to load:", "binaryLoad", temp, this, null, null);
  } catch(Exception ex){
    notifications.add(new Notification("ERROR", new String[]{"Failed to Load File"},200,false));
    println("Exception: ",ex);
  }
}

void LoadMostRecent(){
  try{
  String[] settings = loadStrings(dataPath("settings.settings"));
  File f = new File(settings[0]);
  if (!f.exists()){
    notifications.add(new Notification("ERROR", new String[]{"Failed to Load Most Recent"},200,false));
    return;
  }
  binaryLoad(f);
  notifications.add(new Notification("Load", new String[]{"loaded most recent file",f.getAbsoluteFile().toString().substring(f.getAbsoluteFile().toString().lastIndexOf("\\")+1)},100,true));
  } catch(Exception ex){
    notifications.add(new Notification("ERROR", new String[]{"Failed to Load Most Recent"},200,false));
    println("Load Recent Error: ",ex);
  }
}

int getGlobalLines() {
  if (globalLines == "l turn line") return byte(0);
  if (globalLines == "straight") return byte(1);
  if (globalLines == "straight spline") return byte(2);
  if (globalLines == "spline") return byte(3);
  return 0;
}

String setGlobalLines(int index) {
  return new String[]{"l turn line", "straight", "straight spline", "spline"}[index];
}

byte getGateType(Gate g) {
  if (g.type.equals("AND")) return byte(0);
  else if (g.type.equals("NAND")) return byte(1);
  else if (g.type.equals("NOT")) return byte(2);
  else if (g.type.equals("OR")) return byte(3);
  else if (g.type.equals("NOR")) return byte(4);
  else if (g.type.equals("XOR")) return byte(5);
  else if (g.type.equals("XNOR")) return byte(6);
  else if (g.type.equals("INPUT")) return byte(7);
  else if (g.type.equals("INPUTbp")) return byte(8);
  else if (g.type.equals("INPUT_BUTTON")) return byte(9);
  else if (g.type.equals("INPUT_CLOCK")) return byte(10);
  else if (g.type.equals("OUTPUT")) return byte(11);
  else if (g.type.equals("OUTPUTbp")) return byte(12);
  else if (g.type.equals("OUTPUT_HEX_DISPLAY")) return byte(13);
  else if (g.type.equals("CONNECTOR")) return byte(14);
  return 0;
}

String setGateType(byte index) {
  return new String[]{"AND", "NAND", "NOT", "OR", "NOR", "XOR", "XNOR", "INPUT", "INPUTbp", "INPUT_BUTTON", "INPUT_CLOCK", "OUTPUT", "OUTPUTbp", "OUTPUT_HEX_DISPLAY", "CONNECTOR"}[index];
}

byte getGateInputsUsed(Gate g) {
  byte used = 0;
  for (Connection c : g.connections_in) {
    if (c != null) used++;
  }
  return used;
}

void binarySave(File selectedFile) {
  saved_last = selectedFile;
  try {
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    DataOutputStream data = new DataOutputStream(baos);

    //Saving Global data
    byte global_scale_lines = byte(unbinary(binary(int(round(map(globalScale, 0.5, 5.0, 0.0, 55.0))), 6)+binary(getGlobalLines(), 2))); //converting scale and lines into one byte
    data.writeByte(global_scale_lines);
    data.writeFloat(globalOffset.x);
    data.writeFloat(globalOffset.y);

    //Saving Gates data
    //saving gates amount
    data.writeByte(gates.size() >> 16);
    data.writeByte((gates.size() >> 8) & 255);
    data.writeByte(gates.size() & 255);

    for (Gate g : gates) {
      data.writeByte(getGateType(g)); //write gate type
      data.writeFloat(g.position.x);  //write gate position
      data.writeFloat(g.position.y);
      int in_group = -1;
      for (CustomGate cg : customGates) if (cg.localGates.indexOf(g) != -1) in_group = customGates.indexOf(cg); //check if gate is in blueprint
      byte meta_data = (byte) ((g.powered?1:0) << 7 | (g.hidden?1:0) << 6 | (g.blueprint_input?1:0) << 5 | (g.blueprint_output?1:0) << 4 | (g.poweredFramesMax>0?1:0) << 3 | (in_group>=0?1:0) << 2 | (customGates.size()>255?1:0) << 1); //writing meta data
      data.writeByte(meta_data); //write meta data
      if (g.poweredFramesMax>0) { //check if power requirements
        data.writeByte(byte(g.poweredFramesLeft));
        data.writeByte(byte(g.poweredFramesMax-1));
      }
      if (in_group >= 0) { //check if in blueprint
        if (customGates.size() > 255) data.writeByte((in_group >> 8) & 255);
        data.writeByte(in_group & 255);
      }
      data.writeByte(byte(getGateInputsUsed(g))); //write amount of inputs used
      if (getGateInputsUsed(g)>0) { //write connections
        for (int i = 0; i < g.connections_in.length; i ++) {
          if (g.connections_in[i] != null) {
            int index = gates.indexOf(g.connections_in[i].connector);
            int input_index = g.connections_in[i].inputIndex;
            if (gates.size()>65535) data.writeByte((index >> 16)); //write connector index
            if (gates.size()>255) data.writeByte((index >> 8) & 255); //write connector index
            data.writeByte(index & 255); //write connector index
            data.writeByte(i & 255); //write position index
            data.writeByte(input_index & 255); //write input index
          }
        }
      }
    }
    //Saving Blueprints Data
    //saving blueprints amount
    data.writeByte((customGates.size() >> 8) & 255);
    data.writeByte(customGates.size() & 255);
    for (CustomGate cg : customGates) {
      int is_copy = -1;
      for (CustomGate cgi : customGates) {
        if (cg != cgi && cgi.name.equals(cg.name) && cgi.blueprintSize.equals(cg.blueprintSize) && customGates.indexOf(cg) > customGates.indexOf(cgi)) {
          is_copy = customGates.indexOf(cgi);
          break;
        }
      }
      if (is_copy >= 0) {
        data.writeByte(1);
        if (customGates.size() > 255) data.writeByte((is_copy >> 8) & 255);
        data.writeByte(is_copy & 255);
        data.writeFloat(cg.position.x);
        data.writeFloat(cg.position.y);
      } else {
        byte meta_data = (byte) ((cg.name.length() & 63) << 2 | (cg.minimized?1:0) << 1);
        data.writeByte(meta_data);
        data.writeChars(cg.name);
        data.writeFloat(cg.position.x);
        data.writeFloat(cg.position.y);
        data.writeFloat(cg.blueprintSize.x);
        data.writeFloat(cg.blueprintSize.y);
      }
    }

    saveBytes(selectedFile, compress(baos.toByteArray()));
  } 
  catch(IOException ex) {
  }
}

void binaryLoad(File selectedFile) {
  saved_last = selectedFile;
  if(selectedFile.length() == 0) return;
  try {
    gates = new ArrayList<Gate>();
    customGates = new ArrayList<CustomGate>();
    byte[] fileData = decompress(loadBytes(selectedFile));
    
    //Check if the file has been unzipped or not properly
    if (fileData == null){
     notifications.add(new Notification("ERROR", new String[]{"Failed to Load " + saved_last.getName(),"Corrupted Data"},200,false));
     loop();
     return;
    }
    
    ByteArrayInputStream bais = new ByteArrayInputStream(fileData);
    DataInputStream data = new DataInputStream(bais);

    //Load Global Data
    String global_scale_lines = binary(data.readByte());
    int scale = unbinary(global_scale_lines.substring(0, 6));
    globalScale = float(nf(map(scale, 0, 55, 0.5, 5),0,1));
    globalLines = setGlobalLines(unbinary(global_scale_lines.substring(6, 8))); 
    globalOffset = new PVector(data.readFloat(), data.readFloat());

    //Load gate amount
    int gates_amount = 0;
    gates_amount += data.readUnsignedByte()*65536;
    gates_amount += data.readUnsignedByte()*256;
    gates_amount += data.readUnsignedByte();

    for (int i = 0; i < gates_amount; i++) {
      String gate_name = setGateType(data.readByte()); //load gate name
      PVector gate_position = new PVector(data.readFloat(), data.readFloat()); //load gate position
      Gate g = new Gate(gate_name, gate_position); //create new gate
      String meta_data = binary(data.readByte()); //load meta data
      g.powered = (meta_data.charAt(0)=='1') ? true : false; //assign powered
      g.hidden = (meta_data.charAt(1)=='1') ? true : false; //assign hidden
      g.blueprint_input = (meta_data.charAt(2)=='1') ? true : false; //assign blueprint input
      g.blueprint_output = (meta_data.charAt(3)=='1') ? true : false; //assign blueprint output
      Boolean powered_frames_needed = (meta_data.charAt(4)=='1') ? true : false; //assign powered frames needed
      Boolean part_of_blueprint = (meta_data.charAt(5)=='1') ? true : false; //assign part of blueprint
      Boolean blueprint_bytes_amount = (meta_data.charAt(6)=='1') ? true : false; //assign blueprint bytes amount
      if (powered_frames_needed) {
        g.poweredFramesLeft = data.readUnsignedByte();
        g.poweredFramesMax = data.readUnsignedByte()+1;
      }
      if (part_of_blueprint) {
        int index = 0;
        if (blueprint_bytes_amount) index += data.readUnsignedByte()*256;
        index += data.readUnsignedByte();
        g.blueprint_index = index;
      }
      int connections = data.readUnsignedByte();
      if (connections > 0) {
        for (int j = 0; j < connections; j ++) {
          int index = 0, input_index = 0, position_index = 0;
          if (gates_amount > 65535) index += data.readUnsignedByte()*65536;
          if (gates_amount > 255) index += data.readUnsignedByte()*256;
          index += data.readUnsignedByte();
          position_index = data.readUnsignedByte();
          input_index = data.readUnsignedByte();
          Connection new_connection = new Connection(null, input_index);
          new_connection.gateIndex = index;
          g.connections_in[position_index] = new_connection;
        }
      }
      gates.add(g);
    }

    //Load Blueprints amount
    int blueprints_amount = 0;
    blueprints_amount += data.readUnsignedByte()*256;
    blueprints_amount += data.readUnsignedByte();
    for (int i = 0; i < blueprints_amount; i ++) {
      String meta_data = binary(data.readByte());
      int name_length = unbinary(meta_data.substring(0, 6));
      Boolean minimized = (meta_data.charAt(6)=='1') ? true : false;
      Boolean is_copy = (meta_data.charAt(7)=='1') ? true : false;
      CustomGate new_custom_gate;
      if (is_copy) {
        int blueprint_index = 0;
        if (blueprints_amount > 255) blueprint_index += data.readUnsignedByte()*256;
        blueprint_index += data.readUnsignedByte();
        PVector blueprint_pos = new PVector(data.readFloat(), data.readFloat());
        new_custom_gate = new CustomGate(blueprint_pos, customGates.get(blueprint_index).size);
        new_custom_gate.name = customGates.get(blueprint_index).name;
        new_custom_gate.size = customGates.get(blueprint_index).size;
        new_custom_gate.minimized = customGates.get(blueprint_index).minimized;
      } else {
        String name = "";
        for (int j = 0; j < name_length; j ++) {
          name += data.readChar();
        }
        PVector blueprint_pos = new PVector(data.readFloat(), data.readFloat());
        PVector blueprint_size = PVector.mult(new PVector(data.readFloat(), data.readFloat()),globalScale);
        new_custom_gate = new CustomGate(blueprint_pos, blueprint_size);
        new_custom_gate.minimized = minimized;
        new_custom_gate.name = name;
        new_custom_gate.size = blueprint_size;
      }
      customGates.add(new_custom_gate);
    }

    for (Gate gate : gates) {
      for (Connection c : gate.connections_in) {
        if (c != null) {
          c.connector = gates.get(c.gateIndex);
          gates.get(c.gateIndex).connections_out.add(gate);
        }
      }
      if (gate.blueprint_index >= 0) customGates.get(gate.blueprint_index).localGates.add(gate);
    }
    loop();
  } 
  catch(IOException ex) {
    notifications.add(new Notification("ERROR", new String[]{"Failed to Load File"},200,false));
    println("IOException: ",ex);
  }
}
