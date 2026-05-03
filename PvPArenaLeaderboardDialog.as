package §_-pvp§
{
   import §_-2iP§.§_-1Vi§;
   import §_-4o§.createTextField;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PvPArenaLeaderboardDialog extends PvPArenaDialog
   {
      
      private static const WIDTH:int = 600;
      
      private static const HEIGHT:int = 500;
       
      
      private var _leaderboardData:Array = [];
      
      private var _listContainer:Sprite = null;
      
      public function PvPArenaLeaderboardDialog()
      {
         super(WIDTH,HEIGHT,"Топ игроков PvP");
      }
      
      override public function init() : void
      {
         super.init();
         createUI();
      }
      
      private function createUI() : void
      {
         // Заголовок
         var header:TextField = createTextField(20,30,"Лучшие бойцы арены",0xFFFF00,18);
         addChild(header);
         
         // Список игроков
         this._listContainer = new Sprite();
         this._listContainer.y = 70;
         addChild(this._listContainer);
         
         if(this._leaderboardData.length > 0)
         {
            updateLeaderboard();
         }
         else
         {
            showEmptyMessage();
         }
         
         // Кнопка обновления
         var refreshBtn:§_-4Tm§ = new §_-4Tm§("Обновить",120,30);
         refreshBtn.x = WIDTH / 2 - 60;
         refreshBtn.y = HEIGHT - 60;
         refreshBtn.addEventListener(MouseEvent.CLICK,onRefreshClick);
         addChild(refreshBtn);
      }
      
      public function updateLeaderboard(data:Array = null) : void
      {
         if(data)
         {
            this._leaderboardData = data;
         }
         
         if(this._listContainer)
         {
            removeChild(this._listContainer);
         }
         this._listContainer = new Sprite();
         this._listContainer.y = 70;
         addChild(this._listContainer);
         
         if(this._leaderboardData.length > 0)
         {
            renderLeaderboard();
         }
         else
         {
            showEmptyMessage();
         }
      }
      
      private function renderLeaderboard() : void
      {
         for(var i:int = 0; i < this._leaderboardData.length; i++)
         {
            var entry:Object = this._leaderboardData[i];
            var yPos:int = 10 + i * 40;
            
            // Место
            var rankColor:uint = i < 3 ? (i == 0 ? 0xFFD700 : (i == 1 ? 0xC0C0C0 : 0xCD7F32)) : 0xFFFFFF;
            var rankText:TextField = createTextField(20,yPos,(i + 1) + ".",rankColor,16);
            this._listContainer.addChild(rankText);
            
            // Имя
            var nameText:TextField = createTextField(50,yPos,entry.uid,0xFFFFFF,16);
            nameText.width = 250;
            this._listContainer.addChild(nameText);
            
            // ELO
            var eloColor:uint = entry.elo >= 1200 ? 0xFF00FF : (entry.elo >= 1000 ? 0x00FF00 : 0xFF6600);
            var eloText:TextField = createTextField(320,yPos,entry.elo + " ELO",eloColor,16);
            this._listContainer.addChild(eloText);
            
            // Победы
            var winsText:TextField = createTextField(450,yPos,entry.wins + " поб.",0x00FFFF,14);
            this._listContainer.addChild(winsText);
            
            // Разделитель
            if(i < this._leaderboardData.length - 1)
            {
               var line:Sprite = new Sprite();
               line.graphics.beginFill(0x333333);
               line.graphics.drawRect(0,yPos + 25,WIDTH - 40,2);
               line.graphics.endFill();
               this._listContainer.addChild(line);
            }
         }
      }
      
      private function showEmptyMessage() : void
      {
         var emptyText:TextField = createTextField(WIDTH / 2 - 100,HEIGHT / 2 - 20,"Нет данных о игроках",0x999999,16);
         emptyText.textAlign = "center";
         this._listContainer.addChild(emptyText);
      }
      
      private function onRefreshClick(event:MouseEvent) : void
      {
         // Запросить обновление лидерборда
         var module:PvPArenaModule = §_-6VA§.instance.§_-1OU§(PvPArenaModule.MODULE_ID) as PvPArenaModule;
         if(module && module.netManager)
         {
            // Здесь можно добавить запрос к серверу
         }
      }
   }
}
