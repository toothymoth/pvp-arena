package §_-pvp§
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import §_-4o§.createTextField;
   
   public class PvPButton extends Sprite
   {
      
      private var _title:String;
      
      private var _width:int;
      
      private var _height:int;
      
      private var _enabled:Boolean = true;
      
      private var _baseColor:uint = 0x4A4A6A;
      
      private var _hoverColor:uint = 0x5A5A7A;
      
      private var _disabledColor:uint = 0x2A2A3A;
      
      public function PvPButton(title:String = "Button", width:int = 100, height:int = 30)
      {
         this._title = title;
         this._width = width;
         this._height = height;
         createButton();
      }
      
      private function createButton() : void
      {
         drawButton(this._baseColor);
         
         var text:TextField = createTextField(0,0,this._title,0xFFFFFF,14);
         text.width = this._width;
         text.height = this._height;
         text.textAlign = "center";
         text.verticalAlign = "middle";
         addChild(text);
         
         addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
         addEventListener(MouseEvent.CLICK,onMouseClick);
      }
      
      private function drawButton(color:uint) : void
      {
         graphics.clear();
         graphics.beginFill(color);
         graphics.drawRoundedRect(0,0,this._width,this._height,8);
         graphics.endFill();
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         if(this._enabled)
         {
            drawButton(this._hoverColor);
         }
      }
      
      private function onMouseOut(event:MouseEvent) : void
      {
         if(this._enabled)
         {
            drawButton(this._baseColor);
         }
      }
      
      private function onMouseClick(event:MouseEvent) : void
      {
         if(this._enabled)
         {
            dispatchEvent(event);
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(value:Boolean) : void
      {
         this._enabled = value;
         if(this._enabled)
         {
            drawButton(this._baseColor);
         }
         else
         {
            drawButton(this._disabledColor);
         }
      }
   }
}
