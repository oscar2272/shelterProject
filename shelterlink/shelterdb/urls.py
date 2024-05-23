from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

app_name = "shelterdb"

urlpatterns = [
    path('db', views.home, name='home'),
    path('list/', views.shelter_list, name='shelter_list'),
    path('upload/', views.upload_file, name='upload_file'),
    path('delete_all_shelters/', views.delete_all_shelters, name='delete_all_shelters'),
    
    path('search/', views.ShelterSearch.as_view(), name='shelter_search'),
    path('<int:pk>/',views.ShelterDetailView.as_view()),
    path('<int:shelter_id>/subtract_capacity',views.SubtractShelterCapacityCountView.as_view()),
    path('<int:shelter_id>/add_capacity',views.AddShelterCapacityCountView.as_view()),
]