from django.db import models
class AreaSido(models.Model):
    sido_code = models.CharField(primary_key=True, max_length=10)
    sido_name = models.CharField(max_length=10)

    def __str__(self):
        return self.sido_name

class AreaSigungu(models.Model):
    sigungu_code = models.CharField(primary_key=True, max_length=10)
    sido_code = models.ForeignKey(AreaSido, on_delete=models.CASCADE)
    sigungu_name = models.CharField(max_length=10)

    def __str__(self):
        return self.sigungu_name