from django.contrib import admin
from .models import AreaSido,AreaSigungu


class AreaSigunguAdmin(admin.ModelAdmin):
    fieldsets = [
        ('SI/DO INFORMATION', {'fields': ['sido_code']}),
        ('SI/GUN/GU INFORMATION', {'fields': ['sigungu_code', 'sigungu_name']})
    ]
    list_display = ('sido_code', 'sigungu_name')

admin.site.register(AreaSido)
admin.site.register(AreaSigungu, AreaSigunguAdmin)
