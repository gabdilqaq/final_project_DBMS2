import cx_Oracle
import config

cx_Oracle.init_oracle_client(lib_dir="/Users/Alibek/Downloads/instantclient_19_8")
connection = cx_Oracle.connect(config.username, config.password, config.dsn, encoding=config.encoding)

# objType = connection.gettype("T_TABLE_LENGTH")

# cursor = connection.cursor()
# result = cursor.callfunc('films_filter.length_is', objType)

cursor = connection.cursor()
cursor.execute('select * from table(films_filter.length_is)')
r = cursor.fetchall()

for i in r:
    print(i[0])








