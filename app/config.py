class Config:
    MYSQL_HOST = '192.168.56.10'
    MYSQL_USER = 'flaskuser'
    MYSQL_PASSWORD = 'flaskpass'
    MYSQL_DB = 'myflaskapp'
    SQLALCHEMY_DATABASE_URI = f'mysql://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOST}/{MYSQL_DB}'

