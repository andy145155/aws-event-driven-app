'''
This function will
'''
try:
    import unzip_requirements
except ImportError:
    pass
from utils.apiFunctions import getRdsIamConnection, getRdsSecrets, getCsvFromSQS
from utils.constants import MOVIE_CSV, DB_TABLE


def handler(event, context):
    print(event)
    rds_secret = getRdsSecrets()
    rds_engine = getRdsIamConnection(rds_secret)
    csv_name, csv_object = getCsvFromSQS(event)
    try:
        if csv_name == MOVIE_CSV["CREDITS"]:
            csv_object.to_sql(
                con=rds_engine, name=DB_TABLE["TMDB_CREDITS_RAW_DATA"], if_exists='replace', index=False)
            print(
                f"""{MOVIE_CSV["CREDITS"]} successfully insert into {DB_TABLE["TMDB_CREDITS_RAW_DATA"]} table""")
        elif csv_name == MOVIE_CSV["MOVIES"]:
            csv_object.to_sql(
                con=rds_engine, name=DB_TABLE["TMDB_MOVIE_RAW_DATA"], if_exists='replace', index=False)
            print(
                f"""{MOVIE_CSV["MOVIES"]} successfully insert into {DB_TABLE["TMDB_MOVIE_RAW_DATA"]} table""")
        else:
            raise Exception("Unknown input object")
    except Exception as error:
        print("Error uploading raw movie app data to rds: %s" % (error))

    return
