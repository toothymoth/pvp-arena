package §_-pvp§
{
   import §_-0Um§.§_-3sd§;
   import §_-2-i§.§_-qP§;
   import §_-2SW§.§_-5tR§;
   import §_-6yG§.§_-4O7§;
   import §_-4o3§.§_-2al§;
   import §_-4o3§.§_-5ZY§;
   import ags.§_-3iH§;
   import penzville.city.§_-0yo§;
   
   public class PvPArenaNetManager extends §_-5ZY§
   {
       
      
      public function PvPArenaNetManager()
      {
         §_-05M§ = "pvp.";
         super("pvp_arena", null);
         §_-199§.commandDispatcher.addEventListener(PvPArenaNetCommands.§_-strt§,this.onArenaStart);
         §_-199§.commandDispatcher.addEventListener(PvPArenaNetCommands.§_-jn§,this.onPlayerJoin);
         §_-199§.commandDispatcher.addEventListener(PvPArenaNetCommands.§_-lv§,this.onPlayerLeave);
         §_-199§.commandDispatcher.addEventListener(PvPArenaNetCommands.§_-stt§,this.onBattleStart);
         §_-199§.commandDispatcher.addEventListener(PvPArenaNetCommands.§_-atck§,this.onAttack);
         §_-199§.commandDispatcher.addEventListener(PvPArenaNetCommands.§_-fsh§,this.onBattleFinish);
         §_-199§.commandDispatcher.addEventListener(PvPArenaNetCommands.§_-lbd§,this.onLeaderboard);
         §_-199§.commandDispatcher.addEventListener(PvPArenaNetCommands.§_-err§,this.onError);
         §_-199§.commandDispatcher.addEventListener(PvPArenaNetCommands.§_-cfg§,this.onConfig);
      }
      
      public function createArena(type:String = "public") : void
      {
         var params:§_-5tR§ = new §_-5tR§();
         params.putString("type", type);
         §_-199§.sendExtMessage(PvPArenaNetCommands.§_-crt§,params,§_-Jk§);
      }
      
      public function joinArena(type:String = "public", code:String = "") : void
      {
         var params:§_-5tR§ = new §_-5tR§();
         params.putString("type", type);
         if(code != "")
         {
            params.putString("code", code);
         }
         §_-199§.sendExtMessage(PvPArenaNetCommands.§_-jn§,params,§_-Jk§);
      }
      
      public function leaveArena(room:String) : void
      {
         var params:§_-5tR§ = new §_-5tR§();
         params.putString("room", room);
         §_-199§.sendExtMessage(PvPArenaNetCommands.§_-lv§,params,§_-Jk§);
      }
      
      public function startBattle(room:String) : void
      {
         var params:§_-5tR§ = new §_-5tR§();
         params.putString("room", room);
         §_-199§.sendExtMessage(PvPArenaNetCommands.§_-stt§,params,§_-Jk§);
      }
      
      public function attack(room:String, target:String) : void
      {
         var params:§_-5tR§ = new §_-5tR§();
         params.putString("room", room);
         params.putString("trgt", target);
         §_-199§.sendExtMessage(PvPArenaNetCommands.§_-atck§,params,§_-Jk§);
      }
      
      public function block(room:String) : void
      {
         var params:§_-5tR§ = new §_-5tR§();
         params.putString("room", room);
         §_-199§.sendExtMessage(PvPArenaNetCommands.§_-blck§,params,§_-Jk§);
      }
      
      public function useUltimate(room:String, target:String) : void
      {
         var params:§_-5tR§ = new §_-5tR§();
         params.putString("room", room);
         params.putString("trgt", target);
         §_-199§.sendExtMessage(PvPArenaNetCommands.§_-ult§,params,§_-Jk§);
      }
      
      public function finishBattle(room:String) : void
      {
         var params:§_-5tR§ = new §_-5tR§();
         params.putString("room", room);
         §_-199§.sendExtMessage(PvPArenaNetCommands.§_-fsh§,params,§_-Jk§);
      }
      
      public function configureCharacter(config:Object) : void
      {
         var params:§_-5tR§ = new §_-5tR§();
         params.putObject("config", config);
         §_-199§.sendExtMessage(PvPArenaNetCommands.§_-cfg§,params,§_-Jk§);
      }
      
      private function onArenaStart(param1:§_-4O7§) : void
      {
         dispatchEvent(new §_-4PO§(§_-4PO§.§_-9D§,param1.data));
      }
      
      private function onPlayerJoin(param1:§_-4O7§) : void
      {
         dispatchEvent(new §_-qP§(§_-qP§.§_-08P§,param1.data));
      }
      
      private function onPlayerLeave(param1:§_-4O7§) : void
      {
         dispatchEvent(new §_-qP§(§_-qP§.§_-2Vd§,param1.data));
      }
      
      private function onBattleStart(param1:§_-4O7§) : void
      {
         dispatchEvent(new §_-qP§(§_-qP§.§_-yb§,param1.data));
      }
      
      private function onAttack(param1:§_-4O7§) : void
      {
         dispatchEvent(new §_-qP§(§_-qP§.§_-Yc§,param1.data));
      }
      
      private function onBattleFinish(param1:§_-4O7§) : void
      {
         dispatchEvent(new §_-qP§(§_-qP§.§_-1KS§,param1.data));
      }
      
      private function onLeaderboard(param1:§_-4O7§) : void
      {
         dispatchEvent(new §_-qP§(§_-qP§.§_-58B§,param1.data));
      }
      
      private function onError(param1:§_-4O7§) : void
      {
         var data:Object = param1.data;
         dispatchEvent(new §_-qP§(§_-qP§.§_-36A§,data));
      }
      
      private function onConfig(param1:§_-4O7§) : void
      {
         dispatchEvent(new §_-qP§(§_-qP§.§_-49p§,param1.data));
      }
      
      override public function destroy() : void
      {
         if(destroyed)
         {
            return;
         }
         if(§_-199§ != null)
         {
            §_-199§.commandDispatcher.removeEventListener(PvPArenaNetCommands.§_-strt§,this.onArenaStart);
            §_-199§.commandDispatcher.removeEventListener(PvPArenaNetCommands.§_-jn§,this.onPlayerJoin);
            §_-199§.commandDispatcher.removeEventListener(PvPArenaNetCommands.§_-lv§,this.onPlayerLeave);
            §_-199§.commandDispatcher.removeEventListener(PvPArenaNetCommands.§_-stt§,this.onBattleStart);
            §_-199§.commandDispatcher.removeEventListener(PvPArenaNetCommands.§_-atck§,this.onAttack);
            §_-199§.commandDispatcher.removeEventListener(PvPArenaNetCommands.§_-fsh§,this.onBattleFinish);
            §_-199§.commandDispatcher.removeEventListener(PvPArenaNetCommands.§_-lbd§,this.onLeaderboard);
            §_-199§.commandDispatcher.removeEventListener(PvPArenaNetCommands.§_-err§,this.onError);
            §_-199§.commandDispatcher.removeEventListener(PvPArenaNetCommands.§_-cfg§,this.onConfig);
         }
         super.destroy();
      }
   }
}
