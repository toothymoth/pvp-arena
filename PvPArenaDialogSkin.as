package §_-pvp§
{
   import §_-2iP§.§_-1Vi§;
   import flash.display.Sprite;
   import flash.graphics.Graphics;
   
   public class PvPArenaDialogSkin extends §_-1Vi§
   {
      
      public function PvPArenaDialogSkin()
      {
         super();
      }
      
      override public function draw(param1:Sprite) : void
      {
         var g:Graphics = param1.graphics;
         
         // Фон диалога
         g.beginFill(0x1A1A2E);
         g.drawRect(0,0,stageWidth,stageHeight);
         g.endFill();
         
         // Рамка
         g.beginFill(0x16213E);
         g.drawRect(5,5,stageWidth - 10,stageHeight - 10);
         g.endFill();
         
         // Заголовок
         g.beginFill(0x0F3460);
         g.drawRect(5,5,stageWidth - 10,35);
         g.endFill();
         
         // Декоративные элементы
         g.beginFill(0xE94560);
         g.drawRect(10,15,20,15);
         g.endFill();
         
         super.draw(param1);
      }
   }
}
