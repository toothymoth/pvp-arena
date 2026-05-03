package §_-pvp§
{
   import §_-22Q§.§_-5sS§;
   import §_-2iP§.§_-1Vi§;
   import §_-3Yc§.M1ST17NetManager;
   import §_-5T8§.§_-0bU§;
   import §_-5T8§.§_-16u§;
   import §_-6yG§.§_-4O7§;
   import §_-pvp§.PvPArenaNetManager;
   import §_-pvp§.PvPArenaInfo;
   import §_-pvp§.PvPArenaUIConstructor;
   import §_-pvp§.PvPArenaDialog;
   import §_-pvp§.PvPArenaRoomDialog;
   import §_-pvp§.PvPArenaBattleDialog;
   import §_-pvp§.PvPArenaLeaderboardDialog;
   import adept.config.Configuration;
   import flash.events.MouseEvent;
   import penzville.city.§_-0yo§;
   
   public class PvPArenaModule extends §_-0bU§
   {
      
      public static const MODULE_ID:String = "pvp_arena_2024";
      
      public static const ARENA_LOCATION_ID:String = "pvp_arena";
       
      
      private var _netManager:PvPArenaNetManager = null;
      
      private var _info:PvPArenaInfo = null;
      
      private var _uiConstructor:PvPArenaUIConstructor = null;
      
      private var _currentRoom:String = null;
      
      public function PvPArenaModule()
      {
         super();
      }
      
      public function get info() : PvPArenaInfo
      {
         return this._info;
      }
      
      public function get netManager() : PvPArenaNetManager
      {
         return this._netManager;
      }
      
      override public function prepare(param1:Configuration) : void
      {
         super.prepare(param1);
      }
      
      override public function init() : void
      {
         super.init();
         this._netManager = new PvPArenaNetManager();
         this._netManager.addEventListener(PvPArenaNetCommands.§_-strt§,this.onArenaStart);
         this._netManager.addEventListener(PvPArenaNetCommands.§_-jn§,this.onPlayerJoin);
         this._netManager.addEventListener(PvPArenaNetCommands.§_-lv§,this.onPlayerLeave);
         this._netManager.addEventListener(PvPArenaNetCommands.§_-stt§,this.onBattleStart);
         this._netManager.addEventListener(PvPArenaNetCommands.§_-atck§,this.onAttack);
         this._netManager.addEventListener(PvPArenaNetCommands.§_-fsh§,this.onBattleFinish);
         this._netManager.addEventListener(PvPArenaNetCommands.§_-lbd§,this.onLeaderboard);
         §_-0yo§.§_-02X§.§_-0ho§(this._netManager);
      }
      
      private function onArenaStart(param1:§_-4O7§) : void
      {
         var data:Object = param1.data;
         this._currentRoom = data.room;
         this._info = new PvPArenaInfo();
         this._info.room = data.room;
         this._info.players = data.plrs;
         this._info.owner = data.owner;
         
         // Открываем диалог комнаты
         var dialog:PvPArenaRoomDialog = new PvPArenaRoomDialog(this._info);
         §_-00j§.§_-1pL§(dialog);
         
         dispatchEvent(new §_-4PO§(§_-4PO§.§_-9D§,this._info));
      }
      
      private function onPlayerJoin(param1:§_-4O7§) : void
      {
         if(this._info)
         {
            this._info.players = param1.data.plrs;
         }
         // Обновляем UI комнаты
         updateRoomUI();
      }
      
      private function onPlayerLeave(param1:§_-4O7§) : void
      {
         if(this._info)
         {
            var plrs:Array = this._info.players;
            var idx:int = plrs.indexOf(param1.data.plr);
            if(idx >= 0)
            {
               plrs.splice(idx, 1);
            }
         }
         updateRoomUI();
      }
      
      private function onBattleStart(param1:§_-4O7§) : void
      {
         var data:Object = param1.data;
         // Открываем диалог боя
         var battleDialog:PvPArenaBattleDialog = new PvPArenaBattleDialog(data);
         §_-00j§.§_-1pL§(battleDialog);
      }
      
      private function onAttack(param1:§_-4O7§) : void
      {
         // Обновляем состояние боя
         var battleDialog:§_-4PO§ = §_-00j§.§_-1Sv§(PvPArenaBattleDialog);
         if(battleDialog)
         {
            battleDialog.updateBattleState(param1.data);
         }
      }
      
      private function onBattleFinish(param1:§_-4O7§) : void
      {
         var data:Object = param1.data;
         // Показываем результаты
         // Можно открыть отдельный диалог с наградами
         this._currentRoom = null;
      }
      
      private function onLeaderboard(param1:§_-4O7§) : void
      {
         var data:Object = param1.data;
         // Обновляем лидерборд
         var leaderboardDialog:§_-4PO§ = §_-00j§.§_-1Sv§(PvPArenaLeaderboardDialog);
         if(leaderboardDialog)
         {
            leaderboardDialog.updateLeaderboard(data.top);
         }
      }
      
      private function updateRoomUI() : void
      {
         var roomDialog:§_-4PO§ = §_-00j§.§_-1Sv§(PvPArenaRoomDialog);
         if(roomDialog)
         {
            roomDialog.updatePlayerList(this._info.players);
         }
      }
      
      // Публичные методы для вызова из UI
      public function joinArena(type:String = "public", code:String = "") : void
      {
         this._netManager.joinArena(type, code);
      }
      
      public function startBattle() : void
      {
         this._netManager.startBattle(this._currentRoom);
      }
      
      public function attack(target:String) : void
      {
         this._netManager.attack(this._currentRoom, target);
      }
      
      public function block() : void
      {
         this._netManager.block(this._currentRoom);
      }
      
      public function useUltimate(target:String) : void
      {
         this._netManager.useUltimate(this._currentRoom, target);
      }
      
      public function leaveArena() : void
      {
         this._netManager.leaveArena(this._currentRoom);
         this._currentRoom = null;
      }
      
      override public function get uiConstructor() : §_-16u§
      {
         if(this._uiConstructor == null && inited)
         {
            this._uiConstructor = new PvPArenaUIConstructor();
         }
         return this._uiConstructor;
      }
      
      override public function isActive() : Boolean
      {
         return true; // Всегда доступен
      }
      
      override public function destroy() : void
      {
         if(destroyed)
         {
            return;
         }
         if(this._netManager != null)
         {
            this._netManager.removeEventListener(PvPArenaNetCommands.§_-strt§,this.onArenaStart);
            this._netManager.removeEventListener(PvPArenaNetCommands.§_-jn§,this.onPlayerJoin);
            this._netManager.removeEventListener(PvPArenaNetCommands.§_-lv§,this.onPlayerLeave);
            this._netManager.removeEventListener(PvPArenaNetCommands.§_-stt§,this.onBattleStart);
            this._netManager.removeEventListener(PvPArenaNetCommands.§_-atck§,this.onAttack);
            this._netManager.removeEventListener(PvPArenaNetCommands.§_-fsh§,this.onBattleFinish);
            this._netManager.removeEventListener(PvPArenaNetCommands.§_-lbd§,this.onLeaderboard);
         }
         super.destroy();
      }
   }
}
