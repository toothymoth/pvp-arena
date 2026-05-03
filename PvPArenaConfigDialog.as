package §_-pvp§
{
   import §_-2iP§.§_-1Vi§;
   import §_-4o§.createTextField;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PvPArenaConfigDialog extends PvPArenaDialog
   {
      
      private static const WIDTH:int = 500;
      
      private static const HEIGHT:int = 600;
       
      
      private var _configData:Object = {};
      
      public function PvPArenaConfigDialog(config:Object = null)
      {
         super(WIDTH,HEIGHT,"Настройка персонажа");
         if(config)
         {
            this._configData = config;
         }
      }
      
      override public function init() : void
      {
         super.init();
         createConfigUI();
      }
      
      private function createConfigUI() : void
      {
         // Заголовок
         var title:TextField = createTextField(20,30,"Выберите стиль для боя",0xFFFFFF,16);
         addChild(title);
         
         // Отображение доступных стилей/скинов
         var styles:Sprite = createStylesList();
         styles.y = 60;
         addChild(styles);
         
         // Кнопка сохранения
         var saveBtn:§_-4Tm§ = new §_-4Tm§("Сохранить",150,40);
         saveBtn.x = WIDTH / 2 - 75;
         saveBtn.y = HEIGHT - 70;
         saveBtn.addEventListener(MouseEvent.CLICK,onSaveClick);
         addChild(saveBtn);
      }
      
      private function createStylesList() : Sprite
      {
         var container:Sprite = new Sprite();
         
         // Здесь будет список стилей из инвентаря игрока
         // Для примера добавим несколько заглушек
         var styles:Array = ["Боец", "Воин", "Маг", "Ниндзя"];
         
         for(var i:int = 0; i < styles.length; i++)
         {
            var btn:§_-4Tm§ = new §_-4Tm§(styles[i],200,35);
            btn.x = 20;
            btn.y = 10 + i * 45;
            btn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent,style:String):void
            {
               this._configData.selectedStyle = style;
               saveConfig();
            },false,styles[i]);
            container.addChild(btn);
         }
         
         return container;
      }
      
      private function saveConfig() : void
      {
         var module:PvPArenaModule = §_-6VA§.instance.§_-1OU§(PvPArenaModule.MODULE_ID) as PvPArenaModule;
         if(module)
         {
            module.configureCharacter(this._configData);
         }
      }
      
      private function onSaveClick(event:MouseEvent) : void
      {
         saveConfig();
         close();
      }
   }
}
