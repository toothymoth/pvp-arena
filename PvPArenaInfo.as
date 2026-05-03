package §_-pvp§
{
   public class PvPArenaInfo
   {
      public var room:String;
      public var players:Array;
      public var owner:String;
      public var type:String;
      public var code:String;
      
      public function PvPArenaInfo()
      {
         this.players = [];
      }
      
      public function getPlayerCount() : int
      {
         return this.players.length;
      }
      
      public function isCreator() : Boolean
      {
         return this.owner == §_-0yo§.§_-Gq§.id;
      }
   }
}
