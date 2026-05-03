package §_-pvp§
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import §_-4o§.createTextField;
    
    /**
     * Кнопка действия с анимацией
     */
    public class PvPActionButton extends Sprite
    {
        private var _actionType:String;
        private var _enabled:Boolean = true;
        private var _cooldown:int = 0;
        private var _maxCooldown:int = 0;
        
        private var _bg:Sprite;
        private var _icon:Sprite;
        private var _label:TextField;
        private var _cooldownOverlay:Sprite;
        private var _cooldownText:TextField;
        
        public function PvPActionButton(actionType:String, label:String = "", width:int = 100, height:int = 50)
        {
            super();
            this._actionType = actionType;
            createButton(label, width, height);
        }
        
        private function createButton(label:String, width:int, height:int):void
        {
            var colors:Object = {
                "attack": 0xFF6347,
                "block": 0x4682B4,
                "ultimate": 0x9370DB,
                "skill": 0x32CD32
            };
            
            var color:uint = colors[this._actionType] || 0x4A4A6A;
            this._maxCooldown = this._actionType == "ultimate" ? 30 : 0;
            
            // Фон
            _bg = new Sprite();
            drawBackground(color);
            addChild(_bg);
            
            // Иконка
            _icon = createIcon(color);
            _icon.x = 10;
            _icon.y = (height - 30) / 2;
            addChild(_icon);
            
            // Подпись
            _label = createTextField(45, (height - 16) / 2, label || capitalize(this._actionType), 0xFFFFFF, 14);
            addChild(_label);
            
            // Оверлей кулдауна
            _cooldownOverlay = new Sprite();
            _cooldownOverlay.graphics.beginFill(0x000000, 0.7);
            _cooldownOverlay.graphics.drawRect(0, 0, width, height);
            _cooldownOverlay.graphics.endFill();
            _cooldownOverlay.visible = false;
            addChild(_cooldownOverlay);
            
            // Текст кулдауна
            _cooldownText = createTextField(0, 0, "0", 0xFFFFFF, 20);
            _cooldownText.width = width;
            _cooldownText.textAlign = "center";
            _cooldownText.y = (height - 24) / 2;
            _cooldownOverlay.addChild(_cooldownText);
            
            // События
            addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            addEventListener(MouseEvent.CLICK, onClick);
            
            // Запуск кулдауна
            if(this._maxCooldown > 0) {
                startCooldown();
            }
        }
        
        private function drawBackground(color:uint):void
        {
            _bg.graphics.clear();
            
            // Градиентный фон
            _bg.graphics.beginFill(color);
            _bg.graphics.drawRoundedRect(0, 0, this.width, this.height, 10);
            _bg.graphics.endFill();
            
            // Внутренняя обводка
            _bg.graphics.lineStyle(2, 0xFFFFFF, 0.5);
            _bg.graphics.drawRoundedRect(3, 3, this.width - 6, this.height - 6, 8);
        }
        
        private function createIcon(color:uint):Sprite
        {
            var icon:Sprite = new Sprite();
            
            switch(this._actionType) {
                case "attack":
                    // Меч
                    icon.graphics.beginFill(0xFFFFFF);
                    icon.graphics.moveTo(5, 10);
                    icon.graphics.lineTo(15, 5);
                    icon.graphics.lineTo(15, 15);
                    icon.graphics.lineTo(25, 15);
                    icon.graphics.lineTo(15, 25);
                    icon.graphics.lineTo(15, 20);
                    icon.graphics.lineTo(5, 25);
                    icon.graphics.endFill();
                    break;
                    
                case "block":
                    // Щит
                    icon.graphics.beginFill(0x4169E1);
                    icon.graphics.moveTo(10, 5);
                    icon.graphics.lineTo(20, 5);
                    icon.graphics.lineTo(20, 15);
                    icon.graphics.lineTo(15, 25);
                    icon.graphics.lineTo(10, 15);
                    icon.graphics.endFill();
                    break;
                    
                case "ultimate":
                    // Звезда/взрыв
                    icon.graphics.beginFill(0xFFD700);
                    for(var i:int = 0; i < 5; i++) {
                        var angle:Number = (Math.PI * 2 / 5) * i;
                        var x:Number = Math.cos(angle) * 10 + 15;
                        var y:Number = Math.sin(angle) * 10 + 15;
                        if(i == 0) icon.graphics.moveTo(x, y);
                        else icon.graphics.lineTo(x, y);
                    }
                    icon.graphics.endFill();
                    break;
                    
                case "skill":
                    // Волшебный шар
                    icon.graphics.beginFill(0x32CD32);
                    icon.graphics.drawCircle(15, 15, 10);
                    icon.graphics.endFill();
                    break;
            }
            
            return icon;
        }
        
        private function onMouseOver(e:MouseEvent):void
        {
            if(!this._enabled || this._cooldown > 0) return;
            _bg.alpha = 0.8;
        }
        
        private function onMouseOut(e:MouseEvent):void
        {
            _bg.alpha = 1.0;
        }
        
        private function onClick(e:MouseEvent):void
        {
            if(!this._enabled || this._cooldown > 0) return;
            dispatchEvent(e);
            
            if(this._maxCooldown > 0) {
                startCooldown();
            }
        }
        
        private function startCooldown():void
        {
            this._cooldown = this._maxCooldown;
            _cooldownOverlay.visible = true;
            _cooldownText.text = this._cooldown.toString();
            
            var cdFunc:Function = function():void {
                this._cooldown--;
                if(this._cooldown > 0) {
                    _cooldownText.text = this._cooldown.toString();
                    setTimeout(cdFunc, 1000);
                } else {
                    _cooldownOverlay.visible = false;
                }
            };
            cdFunc();
        }
        
        public function set enabled(value:Boolean):void
        {
            this._enabled = value;
            this.alpha = value ? 1.0 : 0.5;
        }
        
        public function get actionType():String
        {
            return this._actionType;
        }
        
        private function capitalize(str:String):String
        {
            return str.charAt(0).toUpperCase() + str.slice(1);
        }
    }
}
