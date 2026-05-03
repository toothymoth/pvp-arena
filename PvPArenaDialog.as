package §_-pvp§
{
   import §_-22Q§.§_-5sS§;
   import §_-2iP§.§_-1Vi§;
   import §_-4o§.TextField;
   import §_-4o§.createTextField;
   import flash.events.MouseEvent;
   import flash.display.Sprite;
   
   public class PvPArenaDialog extends §_-5sS§
   {
      
      protected var _info:PvPArenaInfo;
      
      public function PvPArenaDialog(param1:int = 500, param2:int = 400, param3:String = "PvP Арена")
      {
         super(param1,param2,param3);
      }
      
      override protected function createSkin() : §_-1Vi§
      {
         return new PvPArenaDialogSkin();
      }
      
      protected function createPlayerList(players:Array) : Sprite
      {
         var container:Sprite = new Sprite();
         
         for(var i:int = 0; i < players.length; i++)
         {
            var text:TextField = createTextField(0,0,players[i],0xFFFFFF,14);
            text.x = 20;
            text.y = 30 + i * 25;
            container.addChild(text);
         }
         
         return container;
      }
   }
}
