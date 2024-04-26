from django.contrib import admin
from .models import AreaSido,AreaSigungu


class AreaSigunguAdmin(admin.ModelAdmin):
    fieldsets = [
        ('SI/DO INFORMATION', {'fields': ['sido_code']}),
        ('SI/GUN/GU INFORMATION', {'fields': ['sigungu_code', 'name']})
    ]
    list_display = ('sido_code', 'name')


admin.site.register(AreaSigungu, AreaSigunguAdmin)
