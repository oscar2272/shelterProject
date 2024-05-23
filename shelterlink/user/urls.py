from django.urls import path
from user import views



urlpatterns = [
    path("data/", views.get_user_data),
    path("kakao/", views.KakaoView.as_view()),
    path("kakao/callback",views.KakaoCallBackView.as_view()),
    path("logout/",views.LogoutView.as_view()),


]