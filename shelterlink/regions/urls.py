from django.urls import path
from .views import SidoListAPI, SigunguListAPI


app_name = "regions"

urlpatterns = [
    path('get_sido_list/', SidoListAPI.as_view(), name='get_sido_list'),
    path('get_sigungu_list/', SigunguListAPI.as_view(), name='get_sigungu_list'),
]
