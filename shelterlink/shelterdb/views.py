from django.shortcuts import render, redirect
from .models import Shelter
from django.urls import reverse
from rest_framework.pagination import PageNumberPagination
from rest_framework import viewsets, filters, pagination,generics
from .serializers import ShelterSerializer
import pandas as pd
from django.shortcuts import redirect
from django.core.exceptions import ValidationError
from shelterdb.models import Shelter

def home(request):
  return render(request, 'shelterdb/home.html')
class ShelterSearchPagination(PageNumberPagination):
    page_size = 10
    page_size_query_param = 'page_size'
    max_page_size = 25
class ShelterSearch(generics.ListAPIView):
    serializer_class = ShelterSerializer
    pagination_class = ShelterSearchPagination

    def get_queryset(self):
        queryset = Shelter.objects.all()

        sido_name = self.request.query_params.get('sido_name')
        sigungu_name = self.request.query_params.get('sigungu_name')

        if sido_name and sigungu_name:
            # 시/도와 시/군/구가 모두 존재하는 경우 해당 지역의 대피소
            queryset = queryset.filter(address__startswith=sido_name).filter(address__icontains=sigungu_name)
        elif sido_name:
            # 시/도만 존재하는 경우 해당 시/도의 대피소
            queryset = queryset.filter(address__startswith=sido_name)
        else:
            queryset = queryset.all()
        return queryset




def shelter_list(request):
    shelters = Shelter.objects.all()
    context = {'shelters': shelters}
    return render(request, 'shelterdb/list.html', context)

def delete_all_shelters(request):
    Shelter.objects.all().delete()
    return redirect(reverse('shelterdb:shelter_list'))


def upload_file(request):
    if 'file' in request.FILES:
        uploaded_file = request.FILES['file']
        # 엑셀 파일을 읽어 pandas DataFrame으로 변환합니다.
        df = pd.read_excel(uploaded_file, header=0)  # 첫 번째 행부터 읽기 시작합니다.

        # 결측값을 처리하고 데이터베이스에 저장합니다.
        for index, row in df.iterrows():
            # 결측값을 처리하고, NaN 값이 포함된 행은 건너뜁니다.
            if row.isnull().values.any():
                continue

            # DataFrame에서 필요한 필드를 추출합니다.
            facility_name = row.iloc[0]  # 첫 번째 열의 데이터
            address = row.iloc[1]  # 두 번째 열의 데이터
            location = row.iloc[2]  # 세 번째 열의 데이터
            area = row.iloc[3]  # 네 번째 열의 데이터
            capacity = row.iloc[4]  # 다섯 번째 열의 데이터

            # area 값을 소수점 버리고 정수형으로 변환합니다.
            try:
                area = int(float(area))  # area 값을 소수점 버리고 정수형으로 변환합니다.
            except ValueError:
                # area 값이 유효하지 않은 경우, 로그를 출력하고 해당 행을 건너뜁니다.
                print(f"Invalid area value in row {index+2}: {area}")
                continue
            
            # 모델 객체를 생성하여 데이터베이스에 저장합니다.
            try:
                shelter = Shelter.objects.create(
                    facility_name=facility_name,
                    address=address,
                    location=location,
                    area=area,
                    capacity=capacity
                )
                shelter.save()
            except ValidationError as e:
                # 모델 유효성 검사에 실패한 경우, 로그를 출력하고 해당 행을 건너뜁니다.
                print(f"Validation error in row {index+2}: {e}")
                continue

        # 저장이 완료되면 리스트 페이지로 리디렉션합니다.
        return redirect('shelterdb:shelter_list')
    else:
        # GET 요청인 경우에는 파일 업로드 페이지를 렌더링합니다.
        return render(request, 'upload.html')