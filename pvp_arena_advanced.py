from modules.base_module import Module
from modules.location import get_city_info, refresh_avatar, gen_plr
import modules.notify as notify
import time
import client as client_test
import random
import asyncio
import json

class_name = "PvPArenaAdvanced"


class PvPArenaAdvanced(Module):
    prefix = "pvp"

    def __init__(self, server):
        self.server = server
        self.arenas = {}
        self.player_arenas = {}
        self.commands = {
            "crt": self.create_arena,
            "jn": self.join_arena,
            "lv": self.leave_arena,
            "stt": self.start_battle,
            "atck": self.attack,
            "blck": self.block,
            "ult": self.use_ultimate,
            "skl": self.use_skill,
            "fsh": self.finish_battle,
            "cfg": self.configure_character,
            "tmf": self.select_team,
            "elc": self.select_element
        }
        
        # Константы баланса
        self.MAX_PLAYERS = 8  # 4 на 4
        self.BASE_HP = 1000
        self.BASE_ATK = 100
        self.BASE_DEF = 50
        self.ULT_COOLDOWN = 30
        self.BATTLE_TIMEOUT = 240
        
        # Элементы и их бонусы
        self.ELEMENTS = {
            "fire": {"atk_mod": 1.15, "def_mod": 0.95, "hp_mod": 1.0, "color": 0xFF4500},
            "water": {"atk_mod": 0.95, "def_mod": 1.1, "hp_mod": 1.2, "color": 0x1E90FF},
            "ice": {"atk_mod": 1.0, "def_mod": 1.2, "hp_mod": 1.0, "color": 0x00BFFF},
            "lightning": {"atk_mod": 1.25, "def_mod": 0.9, "hp_mod": 0.95, "color": 0xFFD700},
            "earth": {"atk_mod": 0.9, "def_mod": 1.25, "hp_mod": 1.3, "color": 0x8B4513},
            "air": {"atk_mod": 1.05, "def_mod": 0.95, "hp_mod": 1.0, "color": 0xF0F8FF}
        }
        
        # Реакции элементов
        self.ELEMENT_REACTIONS = {
            ("fire", "water"): {"effect": "steam", "dmg_mod": 0.5, "status": None},
            ("fire", "ice"): {"effect": "melt", "dmg_mod": 1.5, "status": None},
            ("fire", "earth"): {"effect": "lava", "dmg_mod": 1.2, "status": "burn"},
            ("water", "lightning"): {"effect": "electrocute", "dmg_mod": 1.5, "status": "stun"},
            ("water", "ice"): {"effect": "freeze", "dmg_mod": 1.0, "status": "frozen"},
            ("ice", "lightning"): {"effect": "shatter", "dmg_mod": 1.3, "status": None},
            ("lightning", "earth"): {"effect": "overload", "dmg_mod": 1.2, "status": None},
            ("lightning", "air"): {"effect": "storm", "dmg_mod": 1.4, "status": None},
            ("air", "fire"): {"effect": "inferno", "dmg_mod": 1.3, "status": "burn"}
        }
        
        # Эффекты
        self.EFFECTS = {
            "burn": {"damage": 0.1, "duration": 5, "type": "dot"},
            "freeze": {"damage": 0, "duration": 2, "type": "stun"},
            "stun": {"damage": 0, "duration": 2, "type": "stun"},
            "poison": {"damage": 0.08, "duration": 6, "type": "dot"},
            "bleed": {"damage": 0.12, "duration": 4, "type": "dot"},
            "shield": {"absorb": 0.3, "duration": 3, "type": "shield"},
            "regen": {"heal": 0.05, "duration": 5, "type": "heal"},
            "atk_up": {"atk_mod": 1.3, "duration": 4, "type": "buff"},
            "def_up": {"def_mod": 1.3, "duration": 4, "type": "buff"},
            "speed_up": {"speed_mod": 1.5, "duration": 4, "type": "buff"}
        }

    async def get_player_rank(self, player_uid):
        r = self.server.redis
        rank_data = await r.get(f"pvp:rank:{player_uid}")
        if rank_data:
            return json.loads(rank_data)
        return {"elo": 1000, "wins": 0, "losses": 0, "streak": 0, "element": "fire"}

    async def update_player_rank(self, player_uid, won):
        r = self.server.redis
        rank_data = await self.get_player_rank(player_uid)
        
        opponent_rank = random.randint(800, 1200)
        expected_score = 1 / (1 + 10 ** ((opponent_rank - rank_data["elo"]) / 400))
        actual_score = 1 if won else 0
        k_factor = 32
        
        elo_change = int(k_factor * (actual_score - expected_score))
        rank_data["elo"] += elo_change
        rank_data["wins"] += 1 if won else 0
        rank_data["losses"] += 0 if won else 1
        rank_data["streak"] = rank_data["streak"] + 1 if won else -(rank_data["streak"] + 1)
        
        await r.set(f"pvp:rank:{player_uid}", json.dumps(rank_data))
        return rank_data

    def create_arena_room(self, creator_uid, arena_type="public"):
        room_id = f"pvp_{creator_uid}_{int(time.time())}"
        
        self.arenas[room_id] = {
            "id": room_id,
            "creator": creator_uid,
            "type": arena_type,
            "players": [creator_uid],
            "teams": {},  # team_id -> [player_uids]
            "status": "waiting",
            "battle_start": None,
            "battle_state": {},
            "code": "" if arena_type == "public" else self._generate_room_code(),
            "element_choices": {}  # player_uid -> element
        }
        
        self.player_arenas[creator_uid] = room_id
        return room_id

    def _generate_room_code(self):
        return "".join([random.choice("ABCDEFGH0123456789") for _ in range(6)])

    async def select_element(self, msg, client):
        """Выбор элемента"""
        room_id = msg[2].get("room")
        element = msg[2].get("element")
        
        if room_id not in self.arenas:
            return
        
        if element not in self.ELEMENTS:
            return
        
        arena = self.arenas[room_id]
        arena["element_choices"][client.uid] = element
        
        # Уведомить всех
        for pid in arena["players"]:
            if pid in self.server.online:
                await self.server.online[pid].send(["pvp.elc", {
                    "player": client.uid,
                    "element": element
                }])

    async def select_team(self, msg, client):
        """Выбор команды"""
        room_id = msg[2].get("room")
        team_id = msg[2].get("team")
        
        if room_id not in self.arenas:
            return
        
        arena = self.arenas[room_id]
        players = arena["players"]
        
        # Автоматическое распределение по командам
        if team_id == "auto":
            team_a = players[::2]  # Четные
            team_b = players[1::2]  # Нечетные
            arena["teams"] = {"A": team_a, "B": team_b}
        
        # Уведомить всех
        for pid in players:
            if pid in self.server.online:
                await self.server.online[pid].send(["pvp.tm f", {
                    "teams": arena["teams"]
                }])

    async def create_arena(self, msg, client):
        arena_type = msg[2].get("type", "public")
        
        if client.uid in self.player_arenas:
            await client.send(["pvp.err", {"code": 1, "msg": "Вы уже в арене"}])
            return
        
        room_id = self.create_arena_room(client.uid, arena_type)
        arena = self.arenas[room_id]
        
        await client.send(["pvp.strt", {
            "room": room_id,
            "code": arena["code"],
            "plrs": arena["players"],
            "owner": arena["creator"],
            "type": arena_type,
            "elements": list(self.ELEMENTS.keys())
        }])
        
        leaderboard = await self.get_arena_leaderboard()
        await client.send(["pvp.lbd", {"top": leaderboard}])

    async def join_arena(self, msg, client):
        arena_type = msg[2].get("type", "public")
        
        if arena_type == "private":
            code = msg[2].get("code", "")
            for room_id, arena in self.arenas.items():
                if arena.get("code") == code and arena["status"] == "waiting":
                    if len(arena["players"]) >= self.MAX_PLAYERS:
                        await client.send(["pvp.err", {"code": 2, "msg": "Комната переполнена"}])
                        return
                    await self._add_player(room_id, client.uid)
                    return
            await client.send(["pvp.err", {"code": 3, "msg": "Комната не найдена"}])
            return
        
        elif arena_type == "public":
            for room_id, arena in self.arenas.items():
                if arena["type"] == "public" and arena["status"] == "waiting":
                    if len(arena["players"]) >= self.MAX_PLAYERS:
                        continue
                    await self._add_player(room_id, client.uid)
                    return
            
            room_id = self.create_arena_room(client.uid, "public")
            await client.send(["pvp.strt", {
                "room": room_id,
                "code": "",
                "plrs": [client.uid],
                "owner": client.uid,
                "type": "public",
                "elements": list(self.ELEMENTS.keys())
            }])

    async def _add_player(self, room_id, player_uid):
        arena = self.arenas[room_id]
        arena["players"].append(player_uid)
        self.player_arenas[player_uid] = room_id
        
        for pid in arena["players"]:
            if pid in self.server.online:
                await self.server.online[pid].send(["pvp.jn", {
                    "room": room_id,
                    "plrs": arena["players"],
                    "owner": arena["creator"]
                }])

    async def leave_arena(self, msg, client):
        room_id = msg[2].get("room")
        
        if not room_id or room_id not in self.arenas:
            return
        
        arena = self.arenas[room_id]
        
        if arena["status"] == "fighting":
            await client.send(["pvp.err", {"code": 4, "msg": "Нельзя выйти во время боя"}])
            return
        
        arena["players"].remove(client.uid)
        if client.uid in self.player_arenas:
            del self.player_arenas[client.uid]
        
        for pid in arena["players"]:
            if pid in self.server.online:
                await self.server.online[pid].send(["pvp.lv", {
                    "room": room_id,
                    "plr": client.uid
                }])
        
        if arena["creator"] == client.uid:
            await self._cleanup_arena(room_id)

    async def _cleanup_arena(self, room_id):
        if room_id in self.arenas:
            arena = self.arenas[room_id]
            for pid in arena["players"]:
                if pid in self.player_arenas:
                    del self.player_arenas[pid]
            del self.arenas[room_id]

    async def start_battle(self, msg, client):
        room_id = msg[2].get("room")
        
        if room_id not in self.arenas:
            return
        
        arena = self.arenas[room_id]
        
        if arena["creator"] != client.uid:
            await client.send(["pvp.err", {"code": 5, "msg": "Только создатель может начать бой"}])
            return
        
        if len(arena["players"]) < 2:
            await client.send(["pvp.err", {"code": 6, "msg": "Нужно минимум 2 игрока"}])
            return
        
        arena["status"] = "fighting"
        arena["battle_start"] = int(time.time())
        
        # Автоматическое распределение по командам
        if len(arena["players"]) > 2:
            team_size = len(arena["players"]) // 2
            random.shuffle(arena["players"])
            arena["teams"] = {
                "A": arena["players"][:team_size],
                "B": arena["players"][team_size:]
            }
        
        # Инициализация статов с элементами
        for player_uid in arena["players"]:
            rank_data = await self.get_player_rank(player_uid)
            element = arena["element_choices"].get(player_uid, rank_data.get("element", "fire"))
            elem_bonus = self.ELEMENTS.get(element, self.ELEMENTS["fire"])
            
            hp_mod = 1 + (rank_data["elo"] - 1000) / 10000
            atk_mod = 1 + (rank_data["elo"] - 1000) / 15000
            
            arena["battle_state"][player_uid] = {
                "hp": int(self.BASE_HP * hp_mod * elem_bonus["hp_mod"]),
                "max_hp": int(self.BASE_HP * hp_mod * elem_bonus["hp_mod"]),
                "atk": int(self.BASE_ATK * atk_mod * elem_bonus["atk_mod"]),
                "def": int(self.BASE_DEF * elem_bonus["def_mod"]),
                "element": element,
                "team": None,
                "ult_ready": True,
                "ult_cooldown": 0,
                "shield": 0,
                "effects": []
            }
        
        # Назначаем команды
        for team_id, players in arena["teams"].items():
            for pid in players:
                if pid in arena["battle_state"]:
                    arena["battle_state"][pid]["team"] = team_id
        
        # Отправляем всем начало боя
        for pid in arena["players"]:
            if pid in self.server.online:
                player_state = arena["battle_state"][pid]
                await self.server.online[pid].send(["pvp.stt", {
                    "room": room_id,
                    "players": {
                        uid: {
                            "hp": state["hp"],
                            "max_hp": state["max_hp"],
                            "atk": state["atk"],
                            "element": state["element"],
                            "team": state["team"]
                        } for uid, state in arena["battle_state"].items()
                    },
                    "teams": arena["teams"],
                    "timeout": self.BATTLE_TIMEOUT
                }])

    async def attack(self, msg, client):
        room_id = msg[2].get("room")
        target_uid = msg[2].get("trgt")
        await self._process_action(room_id, client.uid, target_uid, "attack")

    async def block(self, msg, client):
        room_id = msg[2].get("room")
        await self._process_action(room_id, client.uid, None, "block")

    async def use_ultimate(self, msg, client):
        room_id = msg[2].get("room")
        target_uid = msg[2].get("trgt")
        await self._process_action(room_id, client.uid, target_uid, "ultimate")

    async def use_skill(self, msg, client):
        room_id = msg[2].get("room")
        target_uid = msg[2].get("trgt")
        skill_type = msg[2].get("skill")
        await self._process_action(room_id, client.uid, target_uid, "skill", skill_type)

    async def _process_action(self, room_id, attacker_uid, target_uid, action_type, skill_type=None):
        if room_id not in self.arenas:
            return
        
        arena = self.arenas[room_id]
        if arena["status"] != "fighting":
            return
        
        attacker_state = arena["battle_state"].get(attacker_uid)
        if not attacker_state:
            return
        
        # Проверка кулдауна ульта
        if action_type == "ultimate":
            if not attacker_state["ult_ready"]:
                return
            attacker_state["ult_ready"] = False
            attacker_state["ult_cooldown"] = self.ULT_COOLDOWN
        
        # Получаем элементы
        attacker_element = attacker_state.get("element", "fire")
        target_element = None
        if target_uid and target_uid in arena["battle_state"]:
            target_element = arena["battle_state"][target_uid].get("element", "fire")
        
        # Проверяем реакцию элементов
        element_reaction = None
        if target_element:
            reaction_key = (attacker_element, target_element)
            if reaction_key in self.ELEMENT_REACTIONS:
                element_reaction = self.ELEMENT_REACTIONS[reaction_key]
        
        # Расчёт урона
        base_damage = attacker_state["atk"]
        
        if action_type == "attack":
            damage = int(base_damage * random.uniform(0.9, 1.1))
        elif action_type == "block":
            attacker_state["shield"] = int(base_damage * 0.5)
            damage = 0
        elif action_type == "ultimate":
            damage = int(base_damage * random.uniform(1.5, 2.0))
            attacker_state["shield"] = 0
        elif action_type == "skill" and skill_type:
            # Скиллы от элементов
            if skill_type == "heal":
                heal_amount = int(base_damage * 0.5)
                attacker_state["hp"] = min(attacker_state["max_hp"], attacker_state["hp"] + heal_amount)
                damage = -heal_amount  # Отрицательный урон = лечение
            else:
                damage = int(base_damage * 1.2)
        else:
            damage = 0
        
        # Применяем реакцию элементов
        if element_reaction:
            damage = int(damage * element_reaction["dmg_mod"])
        
        # Применяем урон к цели
        if target_uid and target_uid in arena["battle_state"]:
            target_state = arena["battle_state"][target_uid]
            
            # Учитываем щит
            if target_state["shield"] > 0:
                shield_absorb = min(target_state["shield"], damage)
                target_state["shield"] -= shield_absorb
                damage -= shield_absorb
            
            # Учитываем защиту
            actual_damage = max(1, int(damage * (1 - target_state["def"] / (target_state["def"] + 100))))
            target_state["hp"] = max(0, target_state["hp"] - actual_damage)
            
            # Применяем статусы от реакции
            if element_reaction and element_reaction.get("status"):
                status = element_reaction["status"]
                if status in self.EFFECTS:
                    effect_data = self.EFFECTS[status].copy()
                    effect_data["source"] = attacker_uid
                    target_state["effects"].append(effect_data)
        
        # Применяем эффекты (баффы/дебаффы)
        await self._apply_effects(room_id, target_uid)
        
        # Обновление кулдаунов
        for pid, state in arena["battle_state"].items():
            if state["ult_cooldown"] > 0:
                state["ult_cooldown"] -= 1
                if state["ult_cooldown"] <= 0:
                    state["ult_ready"] = True
            
            # Тик эффектов
            new_effects = []
            for effect in state.get("effects", []):
                if effect["duration"] > 1:
                    effect["duration"] -= 1
                    new_effects.append(effect)
            state["effects"] = new_effects
        
        # Отправляем всем обновлённое состояние
        for pid in arena["players"]:
            if pid in self.server.online:
                await self.server.online[pid].send(["pvp.atck", {
                    "room": room_id,
                    "attacker": attacker_uid,
                    "target": target_uid,
                    "action": action_type,
                    "damage": damage if target_uid else 0,
                    "element_reaction": element_reaction["effect"] if element_reaction else None,
                    "states": arena["battle_state"]
                }])
        
        await self._check_battle_end(room_id)

    async def _apply_effects(self, room_id, player_uid):
        """Применить эффекты к игроку"""
        if room_id not in self.arenas:
            return
        
        arena = self.arenas[room_id]
        state = arena["battle_state"].get(player_uid)
        if not state:
            return
        
        for effect in state.get("effects", []):
            if effect["type"] == "dot":
                # Урон со временем
                damage = int(state["max_hp"] * effect["damage"])
                state["hp"] = max(0, state["hp"] - damage)
            elif effect["type"] == "heal":
                # Лечение
                heal = int(state["max_hp"] * effect["heal"])
                state["hp"] = min(state["max_hp"], state["hp"] + heal)
            elif effect["type"] == "buff":
                # Бонусы
                if "atk_mod" in effect:
                    state["atk"] = int(self.BASE_ATK * effect["atk_mod"])
                if "def_mod" in effect:
                    state["def"] = int(self.BASE_DEF * effect["def_mod"])

    async def _check_battle_end(self, room_id):
        if room_id not in self.arenas:
            return
        
        arena = self.arenas[room_id]
        if arena["status"] != "fighting":
            return
        
        # Проверка по командам
        if arena["teams"]:
            team_a_alive = []
            team_b_alive = []
            
            for uid, state in arena["battle_state"].items():
                if state["hp"] > 0:
                    if state["team"] == "A":
                        team_a_alive.append(uid)
                    elif state["team"] == "B":
                        team_b_alive.append(uid)
            
            if not team_a_alive:
                await self._end_battle(room_id, team_b_alive, team_a_alive)
            elif not team_b_alive:
                await self._end_battle(room_id, team_a_alive, team_b_alive)
        else:
            # Обычный бой
            losers = [uid for uid, state in arena["battle_state"].items() if state["hp"] <= 0]
            if losers:
                winners = [uid for uid in arena["players"] if uid not in losers]
                await self._end_battle(room_id, winners, losers)

    async def finish_battle(self, msg, client):
        room_id = msg[2].get("room")
        
        if room_id not in self.arenas:
            return
        
        arena = self.arenas[room_id]
        
        # Определяем победителя по HP
        players_hp = [(uid, state["hp"]) for uid, state in arena["battle_state"].items()]
        players_hp.sort(key=lambda x: x[1], reverse=True)
        
        if players_hp:
            winner = players_hp[0][0] if players_hp[0][1] > 0 else None
            losers = [uid for uid, hp in players_hp if hp <= 0 or uid != winner]
            await self._end_battle(room_id, [winner] if winner else [], losers)

    async def _end_battle(self, room_id, winners, losers):
        arena = self.arenas[room_id]
        arena["status"] = "finished"
        
        for winner_uid in winners:
            await self.update_player_rank(winner_uid, True)
        for loser_uid in losers:
            await self.update_player_rank(loser_uid, False)
        
        results = {
            "room": room_id,
            "winners": winners,
            "losers": losers,
            "teams": arena.get("teams", {}),
            "ranks": {}
        }
        
        for uid in arena["players"]:
            rank_data = await self.get_player_rank(uid)
            results["ranks"][uid] = rank_data
        
        for pid in arena["players"]:
            if pid in self.server.online:
                await self.server.online[pid].send(["pvp.fsh", results])
        
        asyncio.create_task(self._delayed_cleanup(room_id, 10))

    async def _delayed_cleanup(self, room_id, delay):
        await asyncio.sleep(delay)
        await self._cleanup_arena(room_id)

    async def configure_character(self, msg, client):
        config = msg[2].get("config", {})
        r = self.server.redis
        await r.set(f"pvp:config:{client.uid}", str(config))
        await client.send(["pvp.cfg", {"status": "ok", "config": config}])
