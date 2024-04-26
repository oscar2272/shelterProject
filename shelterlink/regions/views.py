from rest_framework import generics
from rest_framework.response import Response
from .models import AreaSido, AreaSigungu
from django.http import JsonResponse

def region_page(request):
    option = request.GET.get('option')  # 옵션 파라미터 가져오기
    sido_code = request.GET.get('sido_code')  # 시/도 코드 가져오기
    sigungu_code = request.GET.get('sigungu_code')  # 시/군/구 코드 가져오기

    if option == 'sido' and not sigungu_code:
        # 시/도만 선택한 경우
        sido_list = list(AreaSido.objects.values())
        return JsonResponse({'sido_list': sido_list})

    elif option == 'sido' and sigungu_code:
        # 시/도와 시/군/구를 모두 선택한 경우
        sigungu_list = list(AreaSigungu.objects.filter(sido_code=sido_code, sigungu_code=sigungu_code).values())
        return JsonResponse({'sigungu_list': sigungu_list})

    elif not option and not sido_code and not sigungu_code:
        # 아무것도 선택하지 않은 경우
        sido_list = list(AreaSido.objects.values())
        return JsonResponse({'sido_list': sido_list})

    else:
        return JsonResponse({'error': 'Invalid option'})

