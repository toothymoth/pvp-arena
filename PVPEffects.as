package §_-pvp§
{
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Rectangle;
    
    /**
     * Визуальные эффекты для боя
     */
    public class PVPEffects extends Sprite
    {
        public function PVPEffects()
        {
            super();
            this.cacheAsBitmap = true;
        }
        
        /**
         * Эффект атаки стихии
         */
        public function showElementAttack(element:String, targetX:Number, targetY:Number):void
        {
            var effect:Sprite = new Sprite();
            effect.x = targetX;
            effect.y = targetY;
            
            var color:uint = PvPElement.COLORS[element] || 0xFFFFFF;
            
            // Рисуем частицы
            for(var i:int = 0; i < 20; i++) {
                var particle:Sprite = new Sprite();
                particle.graphics.beginFill(color);
                particle.graphics.drawCircle(0, 0, Math.random() * 5 + 2);
                particle.graphics.endFill();
                
                particle.x = (Math.random() - 0.5) * 60;
                particle.y = (Math.random() - 0.5) * 60;
                
                effect.addChild(particle);
            }
            
            addChild(effect);
            
            // Анимация
            var frame:int = 0;
            var animate:Function = function():void {
                frame++;
                effect.scaleX += 0.1;
                effect.scaleY += 0.1;
                effect.alpha -= 0.05;
                
                if(frame < 15) {
                    setTimeout(animate, 30);
                } else {
                    removeChild(effect);
                }
            };
            animate();
        }
        
        /**
         * Эффект получения урона
         */
        public function showDamage(targetX:Number, targetY:Number, damage:int, isCrit:Boolean = false):void
        {
            var damageText:§_-4o§.TextField = §_-4o§.createTextField(0, 0, "-" + damage, 0xFF0000, isCrit ? 32 : 24);
            damageText.x = targetX - damageText.width / 2;
            damageText.y = targetY - 50;
            damageText.alpha = 1;
            
            if(isCrit) {
                damageText.text = "CRIT!" + damageText.text;
                damageText.color = 0xFFFF00;
            }
            
            addChild(damageText);
            
            var frame:int = 0;
            var animate:Function = function():void {
                frame++;
                damageText.y -= 2;
                damageText.alpha -= 0.03;
                
                if(frame < 30) {
                    setTimeout(animate, 30);
                } else {
                    if(contains(damageText)) removeChild(damageText);
                }
            };
            animate();
        }
        
        /**
         * Эффект щита
         */
        public function showShield(targetX:Number, targetY:Number, radius:Number):void
        {
            var shield:Sprite = new Sprite();
            shield.x = targetX;
            shield.y = targetY;
            
            shield.graphics.beginFill(0x4169E1, 0.3);
            shield.graphics.drawCircle(0, 0, radius);
            shield.graphics.endFill();
            
            shield.graphics.lineStyle(2, 0x4169E1, 1);
            shield.graphics.drawCircle(0, 0, radius);
            
            // Свечение
            shield.filters = [new GlowFilter(0x4169E1, 1, 10, 10, 2)];
            
            addChild(shield);
            
            var frame:int = 0;
            var animate:Function = function():void {
                frame++;
                shield.rotation += 5;
                shield.alpha -= 0.02;
                
                if(frame < 50) {
                    setTimeout(animate, 30);
                } else {
                    removeChild(shield);
                }
            };
            animate();
        }
        
        /**
         * Эффект статуса (бафф/дебафф)
         */
        public function showStatusEffect(effect:PvPEffect, targetX:Number, targetY:Number):void
        {
            var icon:Sprite = new Sprite();
            icon.x = targetX;
            icon.y = targetY - 30;
            
            var color:uint = effect.getColor();
            
            // Иконка эффекта
            icon.graphics.beginFill(color);
            icon.graphics.drawCircle(0, 0, 15);
            icon.graphics.endFill();
            
            // Буква типа
            var letter:String = effect.type.charAt(0).toUpperCase();
            var text:§_-4o§.TextField = §_-4o§.createTextField(-8, -5, letter, 0xFFFFFF, 14);
            icon.addChild(text);
            
            addChild(icon);
            
            // Анимация парения
            var frame:int = 0;
            var animate:Function = function():void {
                frame++;
                icon.y -= 0.5;
                icon.alpha -= 0.02;
                
                if(frame < 40) {
                    setTimeout(animate, 30);
                } else {
                    removeChild(icon);
                }
            };
            animate();
        }
        
        /**
         * Эффект исцеления
         */
        public function showHeal(targetX:Number, targetY:Number, heal:int):void
        {
            var healText:§_-4o§.TextField = §_-4o§.createTextField(0, 0, "+" + heal, 0x32CD32, 24);
            healText.x = targetX - healText.width / 2;
            healText.y = targetY - 50;
            healText.alpha = 1;
            
            addChild(healText);
            
            var frame:int = 0;
            var animate:Function = function():void {
                frame++;
                healText.y -= 2;
                healText.alpha -= 0.03;
                
                if(frame < 30) {
                    setTimeout(animate, 30);
                } else {
                    if(contains(healText)) removeChild(healText);
                }
            };
            animate();
        }
        
        /**
         * Эффект ультимейта
         */
        public function showUltimate(x:Number, y:Number):void
        {
            var ultimate:Sprite = new Sprite();
            ultimate.x = x;
            ultimate.y = y;
            
            // Взрыв света
            for(var i:int = 0; i < 50; i++) {
                var particle:Sprite = new Sprite();
                var angle:Number = (Math.PI * 2 / 50) * i;
                var distance:Number = Math.random() * 100 + 50;
                
                particle.graphics.beginFill(0xFFD700);
                particle.graphics.drawCircle(0, 0, Math.random() * 8 + 3);
                particle.graphics.endFill();
                
                particle.x = Math.cos(angle) * distance;
                particle.y = Math.sin(angle) * distance;
                
                ultimate.addChild(particle);
            }
            
            addChild(ultimate);
            
            var frame:int = 0;
            var animate:Function = function():void {
                frame++;
                ultimate.scaleX += 0.15;
                ultimate.scaleY += 0.15;
                ultimate.alpha -= 0.03;
                
                if(frame < 25) {
                    setTimeout(animate, 30);
                } else {
                    removeChild(ultimate);
                }
            };
            animate();
        }
        
        /**
         * Эффект реакции стихий
         */
        public function showElementReaction(reaction:String, x:Number, y:Number):void
        {
            var effectColor:uint = 0xFFFFFF;
            var particleCount:int = 30;
            
            switch(reaction) {
                case "steam":
                    effectColor = 0xC0C0C0;
                    particleCount = 40;
                    break;
                case "electrocute":
                    effectColor = 0xFFD700;
                    particleCount = 50;
                    break;
                case "freeze":
                    effectColor = 0x00BFFF;
                    particleCount = 35;
                    break;
                case "melt":
                    effectColor = 0x4682B4;
                    particleCount = 30;
                    break;
                case "lava":
                    effectColor = 0xFF4500;
                    particleCount = 45;
                    break;
                case "inferno":
                    effectColor = 0xFF6347;
                    particleCount = 60;
                    break;
                case "storm":
                    effectColor = 0x9370DB;
                    particleCount = 55;
                    break;
            }
            
            var reactionEffect:Sprite = new Sprite();
            reactionEffect.x = x;
            reactionEffect.y = y;
            
            for(var i:int = 0; i < particleCount; i++) {
                var particle:Sprite = new Sprite();
                particle.graphics.beginFill(effectColor);
                particle.graphics.drawCircle(0, 0, Math.random() * 6 + 2);
                particle.graphics.endFill();
                
                var angle:Number = Math.random() * Math.PI * 2;
                var distance:Number = Math.random() * 80;
                
                particle.x = Math.cos(angle) * distance;
                particle.y = Math.sin(angle) * distance;
                
                reactionEffect.addChild(particle);
            }
            
            addChild(reactionEffect);
            
            var frame:int = 0;
            var animate:Function = function():void {
                frame++;
                reactionEffect.scaleX += 0.1;
                reactionEffect.scaleY += 0.1;
                reactionEffect.alpha -= 0.03;
                
                if(frame < 25) {
                    setTimeout(animate, 30);
                } else {
                    removeChild(reactionEffect);
                }
            };
            animate();
        }
    }
}
