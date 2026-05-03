package §_-pvp§
{
    /**
     * Система эффектов (баффы и дебаффы)
     */
    public class PvPEffect
    {
        // Типы эффектов
        public static const BURN:String = "burn";
        public const FREEZE:String = "freeze";
        public static const STUN:String = "stun";
        public static const POISON:String = "poison";
        public static const BLEED:String = "bleed";
        public static const SHIELD:String = "shield";
        public static const REGENERATION:String = "regeneration";
        public static const SPEED_BOOST:String = "speed_boost";
        public static const ATK_UP:String = "atk_up";
        public static const DEF_UP:String = "def_up";
        public static const BLIND:String = "blind";
        public static const SLOW:String = "slow";
        public static const STEALTH:String = "stealth";
        
        // Цвета эффектов
        public static const COLORS:Object = {
            "burn": 0xFF4500,
            "freeze": 0x00BFFF,
            "stun": 0xFFD700,
            "poison": 0x9932CC,
            "bleed": 0x8B0000,
            "shield": 0x4169E1,
            "regeneration": 0x32CD32,
            "speed_boost": 0xFF69B4,
            "atk_up": 0xFF8C00,
            "def_up": 0x228B22,
            "blind": 0x808080,
            "slow": 0x4682B4,
            "stealth": 0x191970
        };
        
        // Описание эффектов
        public static const DESCRIPTIONS:Object = {
            "burn": "Урон в течение времени",
            "freeze": "Невозможно действовать",
            "stun": "Ошеломление",
            "poison": "Ядовитый урон",
            "bleed": "Кровотечение",
            "shield": "Защитный щит",
            "regeneration": "Восстановление HP",
            "speed_boost": "Ускорение",
            "atk_up": "Усиление атаки",
            "def_up": "Усиление защиты",
            "blind": "Снижение точности",
            "slow": "Замедление",
            "stealth": "Невидимость"
        };
        
        // Длительность эффектов (в тиках боя)
        public static const DURATIONS:Object = {
            "burn": 5,
            "freeze": 2,
            "stun": 2,
            "poison": 6,
            "bleed": 4,
            "shield": 3,
            "regeneration": 5,
            "speed_boost": 4,
            "atk_up": 4,
            "def_up": 4,
            "blind": 3,
            "slow": 3,
            "stealth": 2
        };
        
        // Сила эффектов
        public static const STRENGTHS:Object = {
            "burn": { damage: 0.1, type: "percent" },
            "freeze": { damage: 0, type: "control" },
            "stun": { damage: 0, type: "control" },
            "poison": { damage: 0.08, type: "percent" },
            "bleed": { damage: 0.12, type: "percent" },
            "shield": { absorb: 0.3, type: "absorb" },
            "regeneration": { heal: 0.05, type: "heal" },
            "speed_boost": { speed: 0.5, type: "stat" },
            "atk_up": { atk: 0.3, type: "stat" },
            "def_up": { def: 0.3, type: "stat" },
            "blind": { accuracy: -0.4, type: "stat" },
            "slow": { speed: -0.5, type: "stat" },
            "stealth": { evasion: 0.8, type: "stat" }
        };
        
        public var type:String;
        public var source:String;
        public var duration:int;
        public var maxDuration:int;
        public var data:Object;
        
        public function PvPEffect(type:String, source:String = "", duration:int = -1)
        {
            this.type = type;
            this.source = source;
            this.maxDuration = duration > 0 ? duration : DURATIONS[type] || 3;
            this.duration = this.maxDuration;
            this.data = STRENGTHS[type] || {};
        }
        
        public function isExpired():Boolean
        {
            return this.duration <= 0;
        }
        
        public function tick():void
        {
            this.duration--;
        }
        
        public function getColor():uint
        {
            return COLORS[type] || 0xFFFFFF;
        }
        
        public function getDescription():String
        {
            return DESCRIPTIONS[type] || type;
        }
    }
}
