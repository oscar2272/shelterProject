from rest_framework import serializers
from .models import AreaSido, AreaSigungu

class AreaSidoSerializer(serializers.ModelSerializer):
    class Meta:
        model = AreaSido
        fields = '__all__'

class AreaSigunguSerializer(serializers.ModelSerializer):
    class Meta:
        model = AreaSigungu
        fields = '__all__'
