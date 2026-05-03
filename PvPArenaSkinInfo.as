package §_-pvp§
{
   public class PvPArenaSkinInfo
   {
      public var skinId:String;
      public var name:String;
      public var description:String;
      public var bonuses:Object;
      public var isUnlocked:Boolean;
      
      public function PvPArenaSkinInfo(skinId:String = "", name:String = "", description:String = "", bonuses:Object = null)
      {
         this.skinId = skinId;
         this.name = name;
         this.description = description;
         this.bonuses = bonuses || {};
         this.isUnlocked = true;
      }
      
      public function getAttackBonus() : Number
      {
         return this.bonuses.atk || 0;
      }
      
      public function getDefenseBonus() : Number
      {
         return this.bonuses.def || 0;
      }
      
      public function getHealthBonus() : Number
      {
         return this.bonuses.hp || 0;
      }
   }
}
