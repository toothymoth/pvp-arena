package §_-pvp§
{
   import §_-5T8§.§_-16u§;
   import §_-2iP§.§_-1Vi§;
   
   public class PvPArenaUIConstructor extends §_-16u§
   {
      
      public function PvPArenaUIConstructor()
      {
         super();
      }
      
      override public function createDialog(type:String, params:Object = null) : §_-1Vi§
      {
         switch(type)
         {
            case "room":
               return new PvPArenaRoomDialog(params);
            case "battle":
               return new PvPArenaBattleDialog(params);
            case "leaderboard":
               return new PvPArenaLeaderboardDialog(params);
            case "config":
               return new PvPArenaConfigDialog(params);
            default:
               return new PvPArenaDialog(params);
         }
      }
   }
}
