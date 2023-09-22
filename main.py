from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String, DateTime, BigInteger, select, insert, delete
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.sql import text
from faker import Faker
from random import randint
import generators
import pandas as pd

def insert_stuff_member_stmt(table):
    fake = Faker("ru_RU")
    stmt = insert(stuff).values(user_name=fake.first_name(), user_surname=fake.last_name(), Salary=randint(1000,1e8))
    return stmt

def insert_df_in_db(df_name,engine,table_name):
    #df_name.to_sql(table_name, engine, if_exists="append", index=False)
    df_name.to_csv("data/" + table_name + '.csv',header = False)


db_name = 'postgres'
db_user = 'andrew'
db_pass = '1'
db_host = '0.0.0.0'
db_port = '5432'

conn_url = 'postgresql://{}:{}@{}:{}/{}'.format(db_user, db_pass, db_host, db_port, db_name)

engine = create_engine(conn_url,echo=True)

db = scoped_session(sessionmaker(bind=engine))

meta = MetaData()
# stuff = Table(
#     "stuff",meta,
#     Column("user_id", Integer, primary_key=True),
#     Column("user_name", String(16), nullable=False),
#     Column("user_surname", String(60)),
#     Column("Salary", Integer, nullable=False),
# )
# stuff.create(engine,checkfirst=True)


rows_count = 1000

hero_gen  = generators.HeroGenerator()
player_gen = generators.PlayerGenerator()
sponsors_gen = generators.SponsorGenerator()
team_gen = generators.TeamGenerator()
game_gen = generators.GameGenerator()


heroes = hero_gen.generateHeroes(rows_count)
players = player_gen.generatePlayers(rows_count)
sponsors = sponsors_gen.generateSponsors(rows_count)
teams = team_gen.generateTeams(rows_count)
games = game_gen.generateGames(rows_count)

df_heroes = pd.DataFrame([vars(f) for f in heroes])
df_players = pd.DataFrame([vars(f) for f in players])
df_sponsors = pd.DataFrame([vars(f) for f in sponsors])
df_teams = pd.DataFrame([vars(f) for f in teams])
df_games = pd.DataFrame([vars(f) for f in games])

insert_df_in_db(df_heroes,engine,"heroes")
insert_df_in_db(df_players,engine,"players")
insert_df_in_db(df_sponsors,engine,"sponsor")
insert_df_in_db(df_teams,engine,"team")
insert_df_in_db(df_games,engine,"game")






#print(df_data.head())
#with db.connect() as db1:
#    for i in range(rows_count):
#        stmt = insert_stuff_member_stmt(stuff)
#        db1.execute(stmt)
#    db1.commit()

#s = select(stuff)



#with db.connect() as conn:
#    for row in conn.execute(s):
#        print(row)
#    conn.commit()

