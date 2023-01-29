from django.db import models

# Create your models here.

class TmdbMoviesRawData(models.Model):
    STATUS = (('Released', 'Released'),
              ('Rumored', 'Rumored'),
              ('Other', 'Other'))

    id = models.BigIntegerField(primary_key=True)
    budget = models.BigIntegerField()
    genres = models.JSONField()
    homepage = models.TextField() 
    keywords = models.JSONField() 
    original_language = models.CharField(max_length=30) 
    original_title = models.CharField(max_length=255)
    overview = models.TextField() 
    popularity = models.FloatField() 
    production_companies = models.JSONField() 
    production_countries = models.JSONField() 
    release_date = models.DateField() 
    revenue = models.BigIntegerField()
    runtime = models.IntegerField() 
    spoken_languages = models.JSONField() 
    status = models.CharField(max_length=20, choices=STATUS)
    tagline = models.TextField() 
    title = models.CharField(max_length=255)
    vote_average = models.FloatField() 
    vote_count = models.IntegerField() 

class TmdbCreditsRawData(models.Model):
    movie = models.ForeignKey(TmdbMoviesRawData, on_delete=models.PROTECT, db_column='movieId')
    title = models.CharField(max_length=255)
    cast = models.JSONField()
    crew = models.JSONField()