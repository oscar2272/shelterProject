from django.db import models
from regions.models import AreaSido

class Shelter(models.Model):
    facility_name = models.CharField(max_length=30)
    address = models.CharField(max_length=100)
    area = models.IntegerField() 
    capacity = models.IntegerField()
    capacity_count = models.IntegerField()
    location = models.CharField(max_length=3)
    latitude = models.FloatField()   # 위도
    longitude = models.FloatField()  # 경도
    def __str__(self):
        return self.facility_name
    

