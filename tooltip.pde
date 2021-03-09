class ToolTip{
  String[] tool_tip_text;
  
  ToolTip(String[] ttt){
    this.tool_tip_text = ttt;
  }
  
  void show(){
    fill(255,200);
    strokeWeight(2);
    stroke(40,160,180,255);
    rect(mouseX,min(height-16*tool_tip_text.length,max(mouseY,16*tool_tip_text.length))-(15*tool_tip_text.length),340,26*tool_tip_text.length,10);
    
    fill(0);
    textAlign(CENTER,CENTER);
    textSize(24);
    for(int i = 0; i < tool_tip_text.length; i++){
     text(tool_tip_text[i],mouseX+170,min(height-16*tool_tip_text.length,max(mouseY,16*tool_tip_text.length))-15*tool_tip_text.length+(24*i)+10);
    }
  }
}
