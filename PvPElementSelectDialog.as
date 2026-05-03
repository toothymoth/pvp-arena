package §_-pvp§
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import §_-4o§.createTextField;
    
    /**
     * Диалог выбора элемента для боя
     */
    public class PvPElementSelectDialog extends PvPArenaDialog
    {
        private static const WIDTH:int = 600;
        private static const HEIGHT:int = 500;
        
        private var _room:String;
        private var _elements:Array;
        private var _onElementSelect:Function;
        private var _selectedElement:String;
        
        public function PvPElementSelectDialog(room:String, elements:Array = null)
        {
            super(WIDTH, HEIGHT, "Выберите стихию");
            this._room = room;
            this._elements = elements || ["fire", "water", "ice", "lightning", "earth", "air"];
        }
        
        override public function init():void
        {
            super.init();
            createUI();
        }
        
        private function createUI():void
        {
            // Инструкция
            var info:TextField = createTextField(20, 30, "Выберите стихию для боя:", 0xFFFFFF, 16);
            addChild(info);
            
            // Кнопки элементов
            var elementButtons:Sprite = new Sprite();
            elementButtons.y = 70;
            
            var cols:int = 3;
            var rows:int = Math.ceil(this._elements.length / cols);
            var btnWidth:int = 120;
            var btnHeight:int = 120;
            var spacing:int = 20;
            
            var startX:Number = (WIDTH - (cols * (btnWidth + spacing) - spacing)) / 2;
            
            for(var i:int = 0; i < this._elements.length; i++)
            {
                var element:String = this._elements[i];
                var col:int = i % cols;
                var row:int = int(i / cols);
                
                var btn:PvPElementButton = new PvPElementButton(element, btnWidth, btnHeight);
                btn.x = startX + col * (btnWidth + spacing);
                btn.y = row * (btnHeight + spacing);
                btn.onClickHandler = onElementClick;
                elementButtons.addChild(btn);
            }
            
            addChild(elementButtons);
            
            // Кнопка подтверждения
            var confirmBtn:PvPButton = new PvPButton("Подтвердить", 150, 40);
            confirmBtn.x = WIDTH / 2 - 75;
            confirmBtn.y = HEIGHT - 70;
            confirmBtn.enabled = false;
            confirmBtn.addEventListener(MouseEvent.CLICK, onConfirmClick);
            addChild(confirmBtn);
            
            this._confirmBtn = confirmBtn;
        }
        
        private var _confirmBtn:PvPButton;
        
        private function onElementClick(element:String):void
        {
            this._selectedElement = element;
            
            // Визуальное выделение
            for(var i:int = 0; i < this.numChildren; i++)
            {
                var child:Sprite = this.getChildAt(i) as Sprite;
                if(child is PvPElementButton)
                {
                    var btn:PvPElementButton = child as PvPElementButton;
                    btn.alpha = (btn.getAttribute("element") == element) ? 1.0 : 0.5;
                }
            }
            
            if(this._confirmBtn)
            {
                this._confirmBtn.enabled = true;
            }
        }
        
        private function onConfirmClick(e:MouseEvent):void
        {
            if(this._selectedElement)
            {
                // Отправить выбор на сервер
                var module:PvPArenaModule = §_-6VA§.instance.§_-1OU§(PvPArenaModule.MODULE_ID) as PvPArenaModule;
                if(module && module.netManager)
                {
                    module.netManager.selectElement(this._room, this._selectedElement);
                }
                
                if(this._onElementSelect)
                {
                    this._onElementSelect(this._selectedElement);
                }
                
                close();
            }
        }
        
        public function set onElementSelectHandler(handler:Function):void
        {
            this._onElementSelect = handler;
        }
    }
}
