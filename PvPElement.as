package §_-pvp§
{
    /**
     * Типы стихий и их взаимодействия
     */
    public class PvPElement
    {
        // Типы стихий
        public static const FIRE:String = "fire";
        public static const WATER:String = "water";
        public static const ICE:String = "ice";
        public static const LIGHTNING:String = "lightning";
        public static const EARTH:String = "earth";
        public static const AIR:String = "air";
        
        // Цвета для отображения
        public static const COLORS:Object = {
            "fire": 0xFF4500,
            "water": 0x1E90FF,
            "ice": 0x00BFFF,
            "lightning": 0xFFD700,
            "earth": 0x8B4513,
            "air": 0xF0F8FF
        };
        
        // Иконки (названия спрайтов/ассетов)
        public static const ICONS:Object = {
            "fire": "fire_icon",
            "water": "water_icon",
            "ice": "ice_icon",
            "lightning": "lightning_icon",
            "earth": "earth_icon",
            "air": "air_icon"
        };
        
        // Реакции стихий
        public static const REACTIONS:Object = {
            "fire": {
                "water": { effect: "steam", damageMod: 0.5, status: "burn_removed" },
                "ice": { effect: "melt", damageMod: 1.5, status: "none" },
                "earth": { effect: "lava", damageMod: 1.2, status: "none" }
            },
            "water": {
                "fire": { effect: "steam", damageMod: 0.5, status: "none" },
                "lightning": { effect: "electrocute", damageMod: 1.5, status: "stun" },
                "ice": { effect: "freeze", damageMod: 1.0, status: "frozen" }
            },
            "ice": {
                "fire": { effect: "melt", damageMod: 0.7, status: "none" },
                "water": { effect: "freeze", damageMod: 1.0, status: "frozen" },
                "lightning": { effect: "shatter", damageMod: 1.3, status: "none" }
            },
            "lightning": {
                "water": { effect: "electrocute", damageMod: 1.5, status: "stun" },
                "earth": { effect: "overload", damageMod: 1.2, status: "none" },
                "air": { effect: "storm", damageMod: 1.4, status: "none" }
            },
            "earth": {
                "fire": { effect: "lava", damageMod: 1.2, status: "none" },
                "lightning": { effect: "overload", damageMod: 0.8, status: "none" },
                "air": { effect: "dust", damageMod: 1.0, status: "blind" }
            },
            "air": {
                "fire": { effect: "inferno", damageMod: 1.3, status: "burn" },
                "lightning": { effect: "storm", damageMod: 1.4, status: "none" },
                "earth": { effect: "dust", damageMod: 0.9, status: "none" }
            }
        };
        
        // Баффы от стихий
        public static const BUFFS:Object = {
            "fire": { atk: 15, def: -5, status: "burn_chance" },
            "water": { hp: 20, atk: -5, def: 10, status: "heal_over_time" },
            "ice": { def: 20, speed: -10, status: "freeze_resistance" },
            "lightning": { atk: 25, def: -10, speed: 15, status: "none" },
            "earth": { hp: 30, atk: -10, def: 25, status: "regeneration" },
            "air": { speed: 25, atk: 5, def: -15, status: "evasion" }
        };
        
        /**
         * Получить реакцию между двумя стихиями
         */
        public static function getReaction(attacker:String, defender:String):Object
        {
            if(REACTIONS[attacker] && REACTIONS[attacker][defender]) {
                return REACTIONS[attacker][defender];
            }
            return { effect: "none", damageMod: 1.0, status: "none" };
        }
        
        /**
         * Получить бафф от стихии
         */
        public static function getBuff(element:String):Object
        {
            return BUFFS[element] || { atk: 0, def: 0, hp: 0, speed: 0 };
        }
        
        /**
         * Получить цвет для стихии
         */
        public static function getColor(element:String):uint
        {
            return COLORS[element] || 0xFFFFFF;
        }
    }
}
