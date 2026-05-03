package §_-pvp§
{
   import §_-2iP§.§_-1Vi§;
   import §_-4o§.createTextField;
   import §_-5T8§.§_-0bU§;
   import §_-pvp§.PvPArenaModule;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import penzville.city.§_-0yo§;
   
   public class PvPArenaRoomDialog extends PvPArenaDialog
   {
      
      private static const WIDTH:int = 500;
      
      private static const HEIGHT:int = 400;
       
      
      private var _playersList:Sprite = null;
      
      private var _startButton:§_-4Tm§ = null;
      
      private var _leaveButton:§_-4Tm§ = null;
      
      private var _leaderboardButton:§_-4Tm§ = null;
      
      private var _codeText:TextField = null;
      
      public function PvPArenaRoomDialog(info:PvPArenaInfo)
      {
         super(WIDTH,HEIGHT,"PvP Арена - Комната");
         this._info = info;
      }
      
      override public function init() : void
      {
         super.init();
         createUI();
      }
      
      private function createUI() : void
      {
         // Информация о комнате
         var infoText:TextField = createTextField(20,30,"Комната: " + this._info.room,0xCCCCCC,14);
         addChild(infoText);
         
         var ownerText:TextField = createTextField(20,50,"Создатель: " + this._info.owner,0xCCCCCC,14);
         addChild(ownerText);
         
         var codeLabel:TextField = createTextField(20,80,"Код комнаты (если приватная):",0x999999,12);
         addChild(codeLabel);
         
         this._codeText = createTextField(20,100,this._info.code || "Публичная",0xFFFF00,16);
         this._codeText.selectable = false;
         addChild(this._codeText);
         
         // Список игроков
         var playersLabel:TextField = createTextField(20,140,"Игроки в комнате (" + this._info.players.length + "/4):",0xFFFFFF,14);
         addChild(playersLabel);
         
         this._playersList = createPlayerList(this._info.players);
         this._playersList.y = 165;
         addChild(this._playersList);
         
         // Кнопки
         this._startButton = createButton("Начать бой",120,30,100);
         this._startButton.x = WIDTH / 2 - 120;
         this._startButton.y = HEIGHT - 100;
         this._startButton.addEventListener(MouseEvent.CLICK,onStartClick);
         if(!this._info.isCreator())
         {
            this._startButton.alpha = 0.5;
         }
         addChild(this._startButton);
         
         this._leaderboardButton = createButton("Топ игроков",120,30,100);
         this._leaderboardButton.x = WIDTH / 2;
         this._leaderboardButton.y = HEIGHT - 100;
         this._leaderboardButton.addEventListener(MouseEvent.CLICK,onLeaderboardClick);
         addChild(this._leaderboardButton);
         
         this._leaveButton = createButton("Покинуть",120,30,100);
         this._leaveButton.x = WIDTH / 2 + 120;
         this._leaveButton.y = HEIGHT - 100;
         this._leaveButton.addEventListener(MouseEvent.CLICK,onLeaveClick);
         addChild(this._leaveButton);
      }
      
      private function createButton(title:String,width:int,height:int,yPos:int) : §_-4Tm§
      {
         // Создаём кнопку (используем существующий компонент)
         var btn:§_-4Tm§ = new §_-4Tm§(title,width,height);
         return btn;
      }
      
      public function updatePlayerList(players:Array) : void
      {
         if(this._playersList)
         {
            removeChild(this._playersList);
         }
         this._info.players = players;
         this._playersList = createPlayerList(players);
         this._playersList.y = 165;
         addChild(this._playersList);
      }
      
      private function onStartClick(event:MouseEvent) : void
      {
         if(this._info.isCreator())
         {
            var module:PvPArenaModule = §_-6VA§.instance.§_-1OU§(PvPArenaModule.MODULE_ID) as PvPArenaModule;
            if(module)
            {
               module.startBattle();
            }
         }
      }
      
      private function onLeaderboardClick(event:MouseEvent) : void
      {
         // Открыть диалог лидерборда
         var dialog:PvPArenaLeaderboardDialog = new PvPArenaLeaderboardDialog();
         §_-00j§.§_-1pL§(dialog);
      }
      
      private function onLeaveClick(event:MouseEvent) : void
      {
         var module:PvPArenaModule = §_-6VA§.instance.§_-1OU§(PvPArenaModule.MODULE_ID) as PvPArenaModule;
         if(module)
         {
            module.leaveArena();
         }
         close();
      }
      
      override protected function onCloseClick(param1:MouseEvent) : void
      {
         super.onCloseClick(param1);
         // Если не в бою - покидаем комнату
         var module:PvPArenaModule = §_-6VA§.instance.§_-1OU§(PvPArenaModule.MODULE_ID) as PvPArenaModule;
         if(module && this._info && !module.isActiveBattle())
         {
            module.leaveArena();
         }
      }
   }
}
