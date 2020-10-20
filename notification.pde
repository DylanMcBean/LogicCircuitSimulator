class Notification{
  String title;
  String[] info = null;
  int time, anim_in;
  PShape notification_shape;
  ArrayList<Shape> shapes = new ArrayList<Shape>();
  Boolean ok;
  
  Notification(String title, String[] info, int time, boolean ok){
    this.title = title;
    this.info = info;
    this.time = time+60;
    this.anim_in = 30;
    this.ok = ok;
    //this.notification_shape = notif_shape;
    this.shapes.add(new Shape(new PVector[]{new PVector(0,30),new PVector(0,20),new PVector(0.38,16.1),new PVector(1.52,12.34),new PVector(3.37,8.89),new PVector(5.86,5.86),new PVector(8.89,3.37),new PVector(12.35,1.52),new PVector(16.1,0.38),new PVector(20,0),new PVector(280,0),new PVector(283.9,0.38),new PVector(287.65,1.52),new PVector(292.11,3.37),new PVector(294.14,5.86),new PVector(296.63,8.89),new PVector(298.48,12.35),new PVector(299.62,16.1),new PVector(300,20),new PVector(300,30)}));
    this.shapes.add(new Shape(new PVector[]{new PVector(0,30),new PVector(0,80),new PVector(0.38,83.9),new PVector(1.52,87.65),new PVector(3.37,91.11),new PVector(5.86,94.14),new PVector(8.89,96.63),new PVector(12.35,98.48),new PVector(16.1,99.62),new PVector(20,100),new PVector(280,100),new PVector(283.9,99.61),new PVector(287.65,98.48),new PVector(291.11,96.63),new PVector(294.14,94.14),new PVector(296.61,91.11),new PVector(298.48,87.65),new PVector(299.62,83.9),new PVector(300,80),new PVector(300,30)}));
  }
  
  void show(PVector pos){
    
    for (Shape s : this.shapes) {
      stroke(this.ok ? color(16,176,208) : color(220,16,80));
      fill(ok ? color(96,170,255,100) : color(255,96,100,100));
      strokeWeight(2);
      beginShape();
      for (PVector point : s.points) {
        vertex((pos.x+map(this.anim_in,0,30,0,320))+point.x*map(this.anim_in,0,30,1,0),(pos.y+map(this.anim_in,0,30,0,120))+point.y*map(this.anim_in,0,30,1,0));
      }
      endShape(CLOSE);
    }
    
    if(this.anim_in >-1){
      fill(255);
      textSize(26*+map(this.anim_in,0,30,1,0.01));
      textAlign(CENTER,CENTER);
      text(this.title,pos.x+150+map(this.anim_in,0,30,0,320),pos.y+12+map(this.anim_in,0,30,0,120));
      textSize(18);
      for(int i = 0; i < info.length; i++) {
        text(this.info[i],pos.x+150+map(this.anim_in,0,30,0,320),pos.y+(20*(i)+40)+map(this.anim_in,0,30,0,120));
      }
    }
    this.AnimateIn();
  }
  
  void AnimateIn(){
   if(this.anim_in > 0) this.anim_in--; 
  }
}
