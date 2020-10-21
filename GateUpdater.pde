public class GateUpdater extends Thread{
  logicGates parent;
  GateUpdater(logicGates p){
    this.parent = p;
  }

  public void run(){
    //You can change this condition, just bear in mind that when run returns, the thread is done.
    while(true){
      //Your update stuff, which will repeat forever
      try{
        IntList gate_update_order = new IntList();
        for(int i = 0; i < gates.size(); i ++) gate_update_order.append(i);
        gate_update_order.shuffle();
        for(int i = 0; i < gates.size(); i ++){
          gates.get(gate_update_order.get(i)).update();
        }
      } catch(Exception ex) {}
    }  
  }
}
