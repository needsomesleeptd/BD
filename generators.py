import random

from faker import Faker
from faker.providers.person.en import Provider
class Hero():
    def __init__(self,name,dmg,health,best_player_id,pick_percentage):
        #self.hero_id = id
        self.hero_name = name
        self.damage = dmg
        self.health = health
        self.best_player_id = best_player_id
        self.pick_percentage = pick_percentage


class HeroGenerator():
    def __init__(self,dmg_down = 10,dmg_up =1000,player_count = 1000):
        self.fake_ru = Faker("ru_RU")
        self.fake_eng = Faker()
        self.dmg_down = dmg_down
        self.dmg_up = dmg_up
        self.player_count = player_count

    def generateHeroes(self,count):
        sum_precentage = 99
        hero_names = list(set(Provider.first_names))[::-1]
        heroes = []
        for i in range(count):
            #hero_id = i
            hero_name = hero_names[i]
            hero_dmg = random.randint(self.dmg_down,self.dmg_up)
            hero_health = random.randint(self.dmg_down,self.dmg_up)
            hero_best_player_id = random.randint(1,self.player_count)
            hero_pick_percentage = random.randint(1,sum_precentage)
            ##sum_precentage -= hero_pick_percentage
            hero = Hero(hero_name,hero_dmg,hero_health,hero_best_player_id,hero_pick_percentage)
            heroes.append(hero)
        return heroes



class Player():
    def __init__(self,username=0,name=0,time=0,winrate=0,was_banned=0,is_proffessional=0):
        #self.hero_id = id
        self.player_username = name
        self.player_name = name
        self.time_played = time
        self.was_banned = was_banned
        self.win_rate = winrate
        self.is_professional = is_proffessional

class PlayerGenerator():
    def __init__(self,max_time_played = 5000,player_count = 1000):
        self.fake_ru = Faker("ru_RU")
        self.fake_eng = Faker()
        self.max_time_played = max_time_played
        self.player_count = player_count
    def generatePlayers(self,count):
        players = []
        names = list(set(Provider.first_names))
        for i in range(count):
            player = Player()
            player.player_username = names[i]
            player.player_name = self.fake_ru.unique.name()
            player.time_played = random.randint(1,self.max_time_played)
            player.win_rate = random.randint(1,99)
            player.is_professional = bool(random.randint(0, 1))
            player.was_banned = bool(random.randint(0,1))
            players.append(player)
        return players




class Sponsor():
    def __init__(self):
        self.sponsor_name = None
        self.networth = None
        self.product = None
        self.is_foreign = None

class SponsorGenerator():
    def __init__(self,max_networth = 100000):
        self.fake_ru = Faker("ru_RU")
        self.fake_eng = Faker()
        self.fake_ph = Faker("en_PH")
        self.max_networth = max_networth
    def generateSponsors(self,count):
        sponsors = []
        for i in range(count):
            sponsor = Sponsor()
            sponsor.sponsor_name  = self.fake_eng.company()
            sponsor.networth = random.randint(1,self.max_networth)
            sponsor.product =  self.fake_ph.random_company_product()
            sponsor.is_foreign = bool(random.randint(0,1))
            sponsors.append(sponsor)
        return sponsors


class Team():
    def __init__(self):
        self.team_name = None
        self.is_occupied = None
        self.winnings = None
        self.popularity = None

class TeamGenerator():
    def __init__(self,path_to_teams = "./data/datasets/teams.txt"):
        self.fake_ru = Faker("ru_RU")
        self.fake_eng = Faker()
        self.fake_ph = Faker("en_PH")
        self.team_names = open(path_to_teams).readlines()

    def generateTeams(self,count):
        teams = []
        for i in range(count):
            team = Team()
            team.team_name = self.team_names[i]
            team.popularity = random.randint(1,10000)
            team.winnings = random.randint(1,1e6)
            team.is_occupied = bool(random.randint(0,1))
            teams.append(team)
        return teams




class Game():
    def __init__(self):
        self.player_id = None
        self.hero_id = None
        self.sponsor_id = None
        self.team_id = None
        self.viewers = None
        self.kills = None
        self.duration = None
        self.dark_won = None
        self.time_start = None


class GameGenerator():
    def __init__(self,max_kills = 100, max_duration = 400,people_count = 999,hero_count = 999):
        self.faker = Faker()
        self.max_kills = max_kills
        self.max_duration = max_duration
        self.people_count = people_count
        self.hero_count = hero_count
    def generateGames(self,count):
        games = []
        for i in range(count):
            game = Game()
            game.kills = random.randint(1, self.max_kills)
            game.dark_won = bool(random.randint(0,1))
            game.hero_id = random.randint(1,self.hero_count)
            game.viewers = random.randint(1, 1e4)
            game.duration = random.randint(1,self.max_duration)
            game.player_id = random.randint(1,self.people_count)
            game.sponsor_id = random.randint(1,self.people_count)
            game.team_id = random.randint(1,self.people_count)
            game.time_start = self.faker.date_time()
            games.append(game)
        return games











