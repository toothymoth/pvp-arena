package §_-pvp§
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import §_-4o§.createTextField;
    
    /**
     * Стилизованная кнопка элемента
     */
    public class PvPElementButton extends Sprite
    {
        private var _element:String;
        private var _enabled:Boolean = true;
        private var _onClick:Function;
        
        private var _bg:Sprite;
        private var _icon:Sprite;
        private var _label:TextField;
        
        public function PvPElementButton(element:String, width:int = 80, height:int = 80)
        {
            super();
            this._element = element;
            createButton(width, height);
        }
        
        private function createButton(width:int, height:int):void
        {
            var color:uint = PvPElement.COLORS[this._element] || 0xFFFFFF;
            
            // Фон кнопки
            _bg = new Sprite();
            _bg.graphics.beginFill(0x1A1A2E);
            _bg.graphics.drawRoundedRect(0, 0, width, height, 15);
            _bg.graphics.endFill();
            
            // Рамка
            _bg.graphics.lineStyle(3, color);
            _bg.graphics.drawRoundedRect(2, 2, width - 4, height - 4, 13);
            
            addChild(_bg);
            
            // Иконка элемента
            _icon = createElementIcon(color, width, height);
            _icon.x = width / 2 - _icon.width / 2;
            _icon.y = height / 2 - _icon.height / 2 - 5;
            addChild(_icon);
            
            // Подпись
            _label = createTextField(0, height - 20, capitalize(this._element), color, 10);
            _label.width = width;
            _label.textAlign = "center";
            addChild(_label);
            
            // Свечение
            addGlow(color);
            
            // События
            addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            addEventListener(MouseEvent.CLICK, onClick);
        }
        
        private function createElementIcon(color:uint, width:int, height:int):Sprite
        {
            var icon:Sprite = new Sprite();
            
            switch(this._element) {
                case "fire":
                    // Пламя
                    icon.graphics.beginFill(color);
                    icon.graphics.moveTo(width/2, 0);
                    icon.graphics.lineTo(width/2 - 10, 20);
                    icon.graphics.lineTo(width/2 + 10, 20);
                    icon.graphics.endFill();
                    icon.graphics.beginFill(color, 0.7);
                    icon.graphics.drawCircle(width/2, 10, 8);
                    icon.graphics.endFill();
                    break;
                    
                case "water":
                    // Капля
                    icon.graphics.beginFill(color);
                    icon.graphics.moveTo(width/2, 0);
                    icon.graphics.quadraticCurveTo(width/2 + 15, 15, width/2, 25);
                    icon.graphics.quadraticCurveTo(width/2 - 15, 15, width/2, 0);
                    icon.graphics.endFill();
                    break;
                    
                case "ice":
                    // Кристалл
                    icon.graphics.beginFill(color);
                    icon.graphics.moveTo(width/2, 0);
                    icon.graphics.lineTo(width/2 + 10, 10);
                    icon.graphics.lineTo(width/2, 25);
                    icon.graphics.lineTo(width/2 - 10, 10);
                    icon.graphics.endFill();
                    break;
                    
                case "lightning":
                    // Молния
                    icon.graphics.beginFill(color);
                    icon.graphics.moveTo(width/2, 0);
                    icon.graphics.lineTo(width/2 + 8, 10);
                    icon.graphics.lineTo(width/2 - 5, 10);
                    icon.graphics.lineTo(width/2 - 2, 25);
                    icon.graphics.lineTo(width/2 - 12, 12);
                    icon.graphics.lineTo(width/2 - 2, 12);
                    icon.graphics.endFill();
                    break;
                    
                case "earth":
                    // Круг/горы
                    icon.graphics.beginFill(color);
                    icon.graphics.moveTo(width/2, 5);
                    icon.graphics.lineTo(width/2 + 12, 20);
                    icon.graphics.lineTo(width/2 - 12, 20);
                    icon.graphics.endFill();
                    break;
                    
                case "air":
                    // Вихрь
                    icon.graphics.beginFill(color);
                    icon.graphics.drawCircle(width/2, 12, 10);
                    icon.graphics.drawCircle(width/2 + 5, 12, 5);
                    icon.graphics.endFill();
                    break;
            }
            
            return icon;
        }
        
        private function addGlow(color:uint):void
        {
            var glow:Sprite = new Sprite();
            glow.graphics.beginFill(color, 0.2);
            glow.graphics.drawRoundedRect(-5, -5, this.width + 10, this.height + 10, 20);
            glow.graphics.endFill();
            
            glow.alpha = 0;
            addChildAt(glow, 0);
            
            this._glow = glow;
        }
        
        private var _glow:Sprite;
        
        private function onMouseOver(e:MouseEvent):void
        {
            if(!this._enabled) return;
            
            if(this._glow) {
                var grow:Function = function():void {
                    if(_glow.alpha < 0.6) {
                        _glow.alpha += 0.1;
                        _glow.scaleX += 0.05;
                        _glow.scaleY += 0.05;
                        setTimeout(grow, 30);
                    }
                };
                grow();
            }
        }
        
        private function onMouseOut(e:MouseEvent):void
        {
            if(this._glow) {
                var shrink:Function = function():void {
                    if(_glow.alpha > 0) {
                        _glow.alpha -= 0.1;
                        _glow.scaleX -= 0.05;
                        _glow.scaleY -= 0.05;
                        setTimeout(shrink, 30);
                    }
                };
                shrink();
            }
        }
        
        private function onClick(e:MouseEvent):void
        {
            if(!this._enabled) return;
            if(this._onClick) {
                this._onClick(this._element);
            }
        }
        
        public function set enabled(value:Boolean):void
        {
            this._enabled = value;
            this.alpha = value ? 1.0 : 0.5;
        }
        
        public function set onClickHandler(handler:Function):void
        {
            this._onClick = handler;
        }
        
        private function capitalize(str:String):String
        {
            return str.charAt(0).toUpperCase() + str.slice(1);
        }
    }
}
