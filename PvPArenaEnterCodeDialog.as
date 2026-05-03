package §_-pvp§
{
   import §_-22Q§.§_-5sS§;
   import §_-2iP§.§_-1Vi§;
   import §_-4o§.createTextField;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class PvPArenaEnterCodeDialog extends §_-5sS§
   {
      
      private static const WIDTH:int = 400;
      
      private static const HEIGHT:int = 250;
       
      
      private var _codeInput:TextField = null;
      
      public function PvPArenaEnterCodeDialog()
      {
         super(WIDTH,HEIGHT,"Введите код комнаты");
      }
      
      override protected function createSkin() : §_-1Vi§
      {
         return new PvPArenaDialogSkin();
      }
      
      override public function init() : void
      {
         super.init();
         createUI();
      }
      
      private function createUI() : void
      {
         var label:TextField = createTextField(20,40,"Код комнаты:",0xFFFFFF,14);
         addChild(label);
         
         this._codeInput = createTextField(20,70,"",0xFFFFFF,18);
         this._codeInput.width = WIDTH - 40;
         this._codeInput.height = 30;
         this._codeInput.type = "input";
         this._codeInput.border = true;
         this._codeInput.borderColor = 0x555555;
         addChild(this._codeInput);
         
         var joinBtn:§_-4Tm§ = new §_-4Tm§("Вступить",150,40);
         joinBtn.x = WIDTH / 2 - 75;
         joinBtn.y = HEIGHT - 70;
         joinBtn.addEventListener(MouseEvent.CLICK,onJoinClick);
         addChild(joinBtn);
      }
      
      private function onJoinClick(event:MouseEvent) : void
      {
         var code:String = this._codeInput.text;
         if(code && code.length >= 4)
         {
            var module:PvPArenaModule = §_-6VA§.instance.§_-1OU§(PvPArenaModule.MODULE_ID) as PvPArenaModule;
            if(module)
            {
               module.joinArena("private", code);
            }
            close();
         }
      }
   }
}
