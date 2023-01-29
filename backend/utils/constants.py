RDS_SECRET_NAME = "event-driven-app-db-credentials"
REGION_NAME = "ap-southeast-1"
MOVIE_CSV = {
    "CREDITS":  "tmdb_5000_credits.csv",
    "MOVIES":  "tmdb_5000_movies.csv",
}
DB_TABLE = {
    "TMDB_CREDITS_RAW_DATA": "movie_tmdbcreditsrawdata",
    "TMDB_MOVIE_RAW_DATA": "movie_tmdbmoviesrawdata",
}
S3_BUCKET_NAME = {
    "SSL_BUCKET": "rds-cert-bucket"
}
SSL_FILE_NAME = "ap-southeast-1-bundle.pem"
