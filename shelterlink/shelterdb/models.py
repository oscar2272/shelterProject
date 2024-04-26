from django.db import models
from regions.models import AreaSido

class Shelter(models.Model):
    facility_name = models.CharField(max_length=30)
    address = models.CharField(max_length=100)
    area = models.IntegerField() 
    capacity = models.IntegerField()
    location = models.CharField(max_length=3)

    def __str__(self):
        return self.facility_name
    

