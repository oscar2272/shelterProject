from django.conf import settings
from django.contrib.auth import login,get_user,get_user_model,logout
from django.http import HttpResponse, JsonResponse
from django.shortcuts import redirect
from django.views.generic import View
from rest_framework.response import Response
import requests
from rest_framework.decorators import api_view
from .serializers import UserSerializer
from user.models import CustomUsers
from rest_framework import status
from django.contrib.sessions.models import Session
@api_view(['GET'])
def get_user_data(request):
    user_model = CustomUsers
    session_id = request.headers.get('Authorization').split(' ')[1]  # 'Authorization' 헤더에서 세션 ID 추출
    print("session_id:", session_id)
    if session_id:
        # 세션에 연결된 사용자 ID 가져오기
        session = Session.objects.get(session_key=session_id)
        user_id = session.get_decoded().get('_auth_user_id')
        print(user_id) 
        # 사용자 모델에서 사용자 가져오기
        user = user_model.objects.get(pk=user_id)
        print(user.username)
        
        # 사용자 데이터 반환
        serializer = UserSerializer(user)
        return Response(serializer.data)
    else:
        # 세션이 없을 경우 처리
        return JsonResponse({"error": "Session not found"}, status=status.HTTP_404_NOT_FOUND)

class KakaoView(View):
    def get(self, request):
        kakao_api = "https://kauth.kakao.com/oauth/authorize?response_type=code"
        client_id = "f89b2d5a52ca01c3aed278f0c8e870a7"
        redirect_uri = "http://127.0.0.1:8000/user/kakao/callback"

        return HttpResponse(f"{kakao_api}&client_id={client_id}&redirect_uri={redirect_uri}&prompt=select_account")
  
class KakaoCallBackView(View):
    def get(self, request):
        code = request.GET.get("code")
        print("code:",code) 
        data = {
            "grant_type": "authorization_code",
            "client_id": "f89b2d5a52ca01c3aed278f0c8e870a7",
            "redirect_uri": "http://127.0.0.1:8000/user/kakao/callback",
            "code": code
        }
        kakao_token_api = "https://kauth.kakao.com/oauth/token"
        response = requests.post(kakao_token_api, data=data)
        # -----------------------------------------------
        access_token = response.json().get("access_token")
        # -----------------------------------------------
        kakao_user_api = "https://kapi.kakao.com/v2/user/me"
        user_information = requests.get(kakao_user_api, headers={"Authorization": f"Bearer {access_token}"}).json()

        # Kakao API로부터 받은 사용자 정보
        kakao_user_id = user_information.get("id")
        kakao_user_username = user_information.get("properties", {}).get("nickname")

        try:
            user = CustomUsers.objects.get(user_id=kakao_user_id)
            print("User found:", user)

            login(request, user)
            print("User logged in:", user)

            session_id = request.session.session_key
            user.session_id = session_id
            
            user.save()
            success_script = f''' 
            <script>
                window.LoggedInChannel.postMessage('{user.session_id}');
            </script>
            '''
            return HttpResponse(success_script)
        except CustomUsers.DoesNotExist:
            user = CustomUsers.objects.create_user(
                user_id=kakao_user_id,
                username=kakao_user_username,
            )
           
            login(request, user)
            print("User sign up :",user)
            print("User logged in:", user)
            session_id = request.session.session_key
            
            user.session_id = session_id
            user.save()
            success_script = f''' 
            <script>
                window.LoggedInChannel.postMessage('{user.session_id}');
            </script>
            '''
            return HttpResponse(success_script)
        
class LogoutView(View):
    def get(self, request):
        # 세션을 지우거나 필요한 정리 작업 수행
        logout(request)
        session_id = request.session.session_key
        print("session_id:",session_id)
        return HttpResponse("로그아웃 성공")
