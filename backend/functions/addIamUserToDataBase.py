'''
This function will create a new database user in the mysql server.The new user will have permissionto access 
database by using IAM authentication. Also, SSL connection is necessary when login to rds with the new IAM user. 

More info: https://docs.amazonaws.cn/en_us/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.DBAccounts.html
'''
try:
    import unzip_requirements
except ImportError:
    pass
from utils.apiFunctions import getRdsSecrets
import pymysql


def getRdsConnection(secret):

    # Get DB secret from secret manager object
    db_host = secret['DB_HOST']
    db_user = secret['DB_USER']
    db_iam_user = secret['DB_IAM_USER']
    db_pass = secret['DB_PASSWORD']
    db_name = secret['DB_NAME']

    try:
        rds = pymysql.connect(
            host=db_host,
            user=db_user,
            password=db_pass,
            charset='utf8mb4')

        cursor = rds.cursor()

        create_iam_user_query = f"CREATE USER '{db_iam_user}' IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS';"
        grant_usage_query = f"GRANT ALL PRIVILEGES ON {db_name}.* to '{db_iam_user}'@'%';"
        require_ssl_query = f"ALTER USER '{db_iam_user}' require SSL;"

        cursor.execute(create_iam_user_query)
        cursor.execute(grant_usage_query)
        cursor.execute(require_ssl_query)

        # List mysql user from RDS
        list_user_query = "SELECT user, plugin, host FROM mysql.user"
        cursor.execute(list_user_query)
        mysql_user = cursor.fetchall()
        rds.close()
        if (mysql_user):
            return mysql_user
        else:
            raise Exception("mysql_user not found")

    except Exception as error:
        print("Error creating mysql IAM auth user: %s" % (error))


def handler(event, context):
    print(event)
    rds_secret = getRdsSecrets()
    mysql_user = getRdsConnection(rds_secret)
    return mysql_user
