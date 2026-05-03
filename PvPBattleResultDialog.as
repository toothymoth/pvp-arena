package §_-pvp§
{
    import flash.display.Sprite;
    import §_-4o§.createTextField;
    import flash.events.MouseEvent;
    
    /**
     * Диалог результатов боя
     */
    public class PvPBattleResultDialog extends PvPArenaDialog
    {
        private static const WIDTH:int = 700;
        private static const HEIGHT:int = 550;
        
        private var _results:Object;
        private var _myUid:String;
        
        public function PvPBattleResultDialog(results:Object)
        {
            super(WIDTH, HEIGHT, "Результаты боя");
            this._results = results;
            this._myUid = §_-0yo§.§_-Gq§.id;
        }
        
        override public function init():void
        {
            super.init();
            createUI();
        }
        
        private function createUI():void
        {
            var won:Boolean = this._results.winners.indexOf(this._myUid) >= 0;
            var winColor:uint = won ? 0x32CD32 : 0xFF4500;
            
            // Заголовок
            var title:TextField = createTextField(WIDTH / 2 - 100, 30, won ? "ПОБЕДА!" : "ПОРАЖЕНИЕ", winColor, 32);
            title.textAlign = "center";
            addChild(title);
            
            // Изменение ELO
            var myRank:Object = this._results.ranks[this._myUid];
            if(myRank)
            {
                var eloChange:int = myRank.elo - 1000; // Пример
                var eloColor:uint = eloChange >= 0 ? 0x32CD32 : 0xFF4500;
                var eloText:TextField = createTextField(WIDTH / 2 - 50, 80, 
                    "ELO: " + myRank.elo + " (" + (eloChange >= 0 ? "+" : "") + eloChange + ")", 
                    eloColor, 24);
                eloText.textAlign = "center";
                addChild(eloText);
            }
            
            // Статистика
            var statsTitle:TextField = createTextField(30, 130, "Статистика:", 0xFFFFFF, 18);
            addChild(statsTitle);
            
            if(myRank)
            {
                var winsText:TextField = createTextField(30, 160, 
                    "Побед: " + myRank.wins, 0x32CD32, 16);
                addChild(winsText);
                
                var lossesText:TextField = createTextField(30, 185, 
                    "Поражений: " + myRank.losses, 0xFF4500, 16);
                addChild(lossesText);
                
                var streak:int = myRank.streak || 0;
                var streakColor:uint = streak > 0 ? 0xFFD700 : (streak < 0 ? 0x808080 : 0xFFFFFF);
                var streakText:TextField = createTextField(30, 210, 
                    "Серия: " + (streak > 0 ? "+" : "") + streak, streakColor, 16);
                addChild(streakText);
            }
            
            // Участники боя
            var participantsTitle:TextField = createTextField(WIDTH / 2 - 100, 260, 
                "Участники:", 0xFFFFFF, 18);
            participantsTitle.textAlign = "center";
            addChild(participantsTitle);
            
            // Список игроков
            var listY:Number = 300;
            for(var uid:String in this._results.ranks)
            {
                var rank:Object = this._results.ranks[uid];
                var isWinner:Boolean = this._results.winners.indexOf(uid) >= 0;
                var isMe:Boolean = uid == this._myUid;
                
                var playerColor:uint = isMe ? 0xFFFF00 : (isWinner ? 0x32CD32 : 0x999999);
                var prefix:String = isMe ? "[YOU] " : "";
                
                var playerText:TextField = createTextField(50, listY, 
                    prefix + uid + " - " + rank.elo + " ELO", playerColor, 14);
                playerText.width = WIDTH - 100;
                addChild(playerText);
                
                listY += 25;
            }
            
            // Кнопки
            var continueBtn:PvPButton = new PvPButton("Продолжить", 150, 40);
            continueBtn.x = WIDTH / 2 - 75;
            continueBtn.y = HEIGHT - 60;
            continueBtn.addEventListener(MouseEvent.CLICK, onCloseClick);
            addChild(continueBtn);
        }
        
        private function onCloseClick(e:MouseEvent):void
        {
            close();
        }
    }
}
